//
//  ContentAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation
import SQLite

// MARK: - Memory access

struct ContentAccess {
    
    let database: DatabaseService
    let db2: DatabaseService2
    let labelAccess: LabelAccess
}

extension ContentAccess {
    
    func store(items: [ContentItem], source: ContentSource) {
        let context = database.childContext
        var labels: Set<String> = []
        items.forEach { meta in
            meta.labels.forEach { name in
                labels.insert(name)
            }
        }
        
        context.perform {
            let labelEntities = try! labelAccess.findOrCreate(labels: Array(labels), context: context)
            let labelDict = Dictionary(grouping: labelEntities) { $0.name }.mapValues { $0[0] }
            let contextSource = context.object(with: source.objectID) as! ContentSource
            let ids = items.map { $0.id }
            let fetch = ContentEntity.fetch()
            fetch.predicate = NSPredicate(format: "id IN %@", ids)
            
            let existing = try! context.fetch(fetch)
            let existingIDs = existing.map { $0.id }
            let toCreate = items.filter { !existingIDs.contains($0.id) }
            toCreate.forEach { item in
                let entity = ContentEntity(context: context)
                entity.id = item.id
                entity.title = item.title
                entity.created = item.created
                entity.thumbnail = item.thumbnail
                entity.url = item.url
                entity.sources.insert(contextSource)
                
                for label in item.labels {
                    entity.labelEntities.insert(labelDict[label]!)
                }
                
            }
            try! context.save()
            self.database.saveToDisk()
        }
        
        let setters: [[Setter]] = items.map { ContentTable.setters(item: $0) }
        _ = try? db2.db.run(ContentTable.table.insertMany(or: .ignore, setters))
    }
    
    
}

extension ContentAccess {
    
    struct ContentTable {
        static let table = Table("content")
        static let id = Expression<String>("id")
        static let title = Expression<String?>("title")
        static let url = Expression<String?>("url")
        static let thumbnail = Expression<String?>("thumbnail")
        static let created = Expression<Double>("created")
        
        static func create(db: Connection) throws {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(url)
                t.column(thumbnail)
                t.column(created)
            })
        }
        
        static func setters(item: ContentItem) -> [Setter] {
            return [
                Self.id <- item.id,
                Self.title <- item.title,
                Self.url <- item.url,
                Self.thumbnail <- item.thumbnail,
                Self.created <- item.created,
            ]
        }
    }
    
    struct ContentLabelTable {
        static let table = Table("content_label")
        static let content_id = Expression<String>("content_id")
        static let label_id = Expression<Int64>("label_id")
        
        static func create(db: Connection) throws {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(content_id)
                t.column(label_id)
                t.foreignKey(content_id, references: ContentTable.table, ContentTable.id, delete: .noAction)
                t.foreignKey(label_id, references: LabelAccess.LabelTable.table, LabelAccess.LabelTable.id, delete: .noAction)
            })
        }
    }
    
    struct ContentSourceTable {
        static let table = Table("content_source")
        static let content_id = Expression<String>("content_id")
        static let source_id = Expression<Int64>("source_id")
        
        static func create(db: Connection) throws {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(content_id)
                t.column(source_id)
                t.foreignKey(content_id, references: ContentAccess.ContentTable.table, ContentTable.id, delete: .noAction)
                t.foreignKey(source_id,
                             references: ContentSourceAccess.SourceTable.table,
                             ContentSourceAccess.SourceTable.id, delete: .noAction
                )
            })
        }
    }
    
}
