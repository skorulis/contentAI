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
    
    let db: DatabaseService
    let labelAccess: LabelAccess
}

extension ContentAccess {
    
    func store(items: [ContentItem], source: Source) {
        assert(source.id != 0)
        var labels: Set<String> = []
        items.forEach { meta in
            meta.labels.forEach { name in
                labels.insert(name)
            }
        }
        
        let labelEntities = labelAccess.findOrCreate(labels: Array(labels))
        let labelDict = Dictionary(grouping: labelEntities) { $0.name }.mapValues { $0[0] }
        
        let setters: [[Setter]] = items.map { ContentTable.setters(item: $0) }
        _ = try? db.db.run(ContentTable.table.insertMany(or: .ignore, setters))
        
        // TODO: Insert labels
        
        
        
        // TODO: Insert source
        
        let sourceSetters = items.map { ContentSourceTable.setters(source: source, item: $0) }
        _ = try! db.db.run(ContentSourceTable.table.insertMany(or: .replace, sourceSetters))
        
    }
    
    func sourceItems(source: Source) -> [ContentItem] {
        let query = ContentTable.table
            .join(
                ContentSourceTable.table,
                on: ContentSourceTable.content_id == ContentTable.table[ContentTable.id]
            )
            .filter(ContentSourceTable.source_id == source.id)
        
        return try! db.db.prepare(query).map { try! ContentTable.extract(row: $0) }
    }
    
    func all() -> [ContentItem] {
        let query = ContentTable.table
        return try! db.db.prepare(query).map { try! ContentTable.extract(row: $0) }
    }
    
    func publisher(source: Source) -> QueryPublisher<ContentItem> {
        let query = ContentTable.table
            .join(
                ContentSourceTable.table,
                on: ContentSourceTable.content_id == ContentTable.table[ContentTable.id]
            )
            .filter(ContentSourceTable.source_id == source.id)
        
        
        return QueryPublisher<ContentItem>(db: db.db, baseQuery: query) { row in
            return try! ContentTable.extract(row: row)
        }
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
        
        static func extract(row: Row) throws -> ContentItem {
            return ContentItem(
                id: try row.get(id),
                title: try row.get(title),
                url: try row.get(url),
                thumbnail: try row.get(thumbnail),
                created: try row.get(created),
                labels: []
            )
        }
    }
    
    struct ContentLabelTable {
        static let table = Table("content_label")
        static let content_id = Expression<String>("content_id")
        static let label_id = Expression<Int64>("label_id")
        
        static func setters(label: Label, item: ContentItem) -> [Setter] {
            return [
                content_id <- item.id,
                label_id <- label.id
            ]
        }
        
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
        
        static func setters(source: Source, item: ContentItem) -> [Setter] {
            return [
                content_id <- item.id,
                source_id <- source.id
            ]
        }
        
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
