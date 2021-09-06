//
//  ProjectAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Combine
import Foundation
import SQLite

struct ContentSourceAccess {
    
    let db: DatabaseService
    
    let publisher: CurrentValueSubject<[Source], Never> = .init([])
    
    init(db: DatabaseService) {
        self.db = db
        self.updatePublisher()
    }
}

extension ContentSourceAccess {
    
    func get(id: Int64) throws -> Source? {
        assert(Thread.current.isMainThread)
        let query = SourceTable.table.filter(SourceTable.id == id)
        
        for row in try db.db.prepare(query) {
            return try SourceTable.extract(row: row)
        }
        return nil
    }
    
    func get(name: String) throws -> Source? {
        let query = SourceTable.table.filter(SourceTable.name == name)
        
        for row in try db.db.prepare(query) {
            return try SourceTable.extract(row: row)
        }
        return nil
    }
    
    func delete(id: Int64) {
        let query = SourceTable.table.filter(SourceTable.id == id)
        try! db.db.run(query.delete())
    }
    
    func save(source: Source) -> Source{
        let setters = SourceTable.setters(source: source)
        let query = SourceTable.table.insert(or: .replace, setters)
        let id = try! db.db.run(query)
        
        self.updatePublisher()
        
        return Source(
            id: id,
            name: source.name,
            sourceType: source.sourceType,
            config: source.config
        )
    }
    
    func all() -> [Source] {
        let query = SourceTable.table
        return try! db.db.prepare(query).map { try! SourceTable.extract(row: $0) }
    }
    
    func updatePublisher() {
        self.publisher.value = all()
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
