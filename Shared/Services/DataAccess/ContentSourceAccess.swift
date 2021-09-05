//
//  ProjectAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import CoreData
import Foundation
import SQLite

struct ContentSourceAccess {
    
    let database: DatabaseService
    let db2: DatabaseService2
}

extension ContentSourceAccess {
    
    func get(id: Int64) throws -> Source? {
        assert(Thread.current.isMainThread)
        let query = SourceTable.table.filter(SourceTable.id == id)
        
        for row in try db2.db.prepare(query) {
            return try SourceTable.extract(row: row)
        }
        return nil
    }
    
    func delete(id: Int64) {
        let query = SourceTable.table.filter(SourceTable.id == id)
        try! db2.db.run(query.delete())
    }
    
    func save(source: Source) -> Source{
        let setters = SourceTable.setters(source: source)
        let query = SourceTable.table.insert(or: .replace, setters)
        let id = try! db2.db.run(query)
        
        return Source(
            id: id,
            name: source.name,
            sourceType: source.sourceType,
            config: source.config
        )
    }
    
    /*func publisher() -> FetchedResultsControllerPublisher<ContentSource> {
        return FetchedResultsControllerPublisher(fetchedResultsController: fetchController())
    }
    
    func fetchController() -> NSFetchedResultsController<ContentSource> {
        let context = database.mainContext
        let req: NSFetchRequest<ContentSource> = ContentSource.fetch()
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }*/
    
    func all() -> [Source] {
        let query = SourceTable.table
        return try! db2.db.prepare(query).map { try! SourceTable.extract(row: $0) }
    }
}

extension ContentSourceAccess {
    
    struct SourceTable {
        static let table = Table("source")
        static let id = Expression<Int64>("id")
        static let name = Expression<String>("name")
        static let sourceType = Expression<String>("source_type")
        static let config = Expression<Data?>("config")
        
        static func create(db: Connection) throws {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name)
                t.column(sourceType)
                t.column(config)
            })
        }
        
        static func setters(source: Source) -> [Setter] {
            var output = [
                name <- source.name,
                sourceType <- source.sourceType.rawValue,
                config <- source.config
            ]
            
            if source.id != 0 {
                output.append(id <- source.id)
            }
            return output
        }
        
        static func extract(row: Row) throws -> Source {
            return Source(
                id: try row.get(id),
                name: try row.get(name),
                sourceType: try Source.SourceType(rawValue: row.get(sourceType))!,
                config: try row.get(config)
            )
        }
    }
    
}
