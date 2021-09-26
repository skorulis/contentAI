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
        
        let ids = items.map { $0.id }
        
        // TODO: Insert labels
        
        let existingQuery = ContentSourceTable.table
            .filter(ContentSourceTable.source_id == source.id)
            .filter(ids.contains(ContentSourceTable.content_id))
        
        let existing = try! db.db.prepare(existingQuery).map { row in
            return try! row.get(ContentSourceTable.content_id)
        }
        
        let needingLink = ids.filter { !existing.contains($0) }
        if needingLink.count > 0 {
            let sourceSetters = needingLink.map { ContentSourceTable.setters(source: source, itemID: $0) }
            _ = try! db.db.run(ContentSourceTable.table.insertMany(or: .replace, sourceSetters))
        }
    }
    
    func updateType(ids: [String], type: ContentType) {
        let query = ContentTable.table
            .filter(ids.contains(ContentTable.id))
            .update(ContentTable.contentType <- type.rawValue)
        
        try! db.db.run(query)
    }
    
    func sourceItems(source: Source) -> [ContentItem] {
        let query = sourceQuery(sources: [source])
        var content = try! db.db.prepare(query).map { try! ContentTable.extract(row: $0) }
        let ids = content.map { $0.id }
        let labels = Dictionary(grouping: allLabels(contentIDs: ids), by: {$0.contentID} )
        
        for i in 0..<content.count {
            let id = content[i].id
            content[i].labels = (labels[id] ?? []).map { $0.label.name }
        }
        return content
    }
    
    func sourceQuery(sources: [Source]) -> Table {
        let ids = sources.map { $0.id }
        let query = ContentTable.table
            .join(
                ContentSourceTable.table,
                on: ContentSourceTable.content_id == ContentTable.table[ContentTable.id]
            )
            .filter(ids.contains(ContentSourceTable.source_id))
        
        return query
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
    
    func addLabel(contentID: String, text: String) {
        let label = labelAccess.findOrCreate(labels: [text]).first!
        let query = ContentLabelTable.table
            .filter(ContentLabelTable.content_id == contentID)
            .filter(ContentLabelTable.label_id == label.id)
            
        let existing = try! db.db.prepare(query).map { $0 }
        if existing.count > 0 {
            return
        }
        
        let setters: [Setter] = ContentLabelTable.setters(labelID: label.id, itemID: contentID)
        _ = try! db.db.run(ContentLabelTable.table.insert(setters))
    }
    
    func deleteLabel(contentID: String, text: String) {
        let label = labelAccess.findOrCreate(labels: [text]).first!
        let query = ContentLabelTable.table
            .filter(ContentLabelTable.content_id == contentID)
            .filter(ContentLabelTable.label_id == label.id)
            .delete()
        
        _ =     try? db.db.run(query)
    }
    
    func allLabels(contentIDs: [String]) -> [ContentLabel] {
        let query = ContentLabelTable.table
            .filter(contentIDs.contains(ContentLabelTable.content_id))
            .join(LabelAccess.LabelTable.table, on: ContentLabelTable.label_id == LabelAccess.LabelTable.id)
        
        return try! db.db.prepare(query).map { row in
            return try ContentLabelTable.extract(row: row)
        }
    }
    
    func markViewed(contentID: String) {
        let query = ContentTable.table
            .filter(ContentTable.id == contentID)
            .update([ContentTable.viewed <- true])
        
        try! db.db.run(query)
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
        static let viewed = Expression<Bool>("viewed")
        static let cached = Expression<Bool>("cached")
        static let contentType = Expression<Int>("content_type")
        
        static func create(db: Connection) throws {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(url)
                t.column(thumbnail)
                t.column(created)
                t.column(viewed, defaultValue: false)
                t.column(cached, defaultValue: false)
                t.column(contentType, defaultValue: ContentType.unchecked.rawValue)
            })
        }
        
        static func setters(item: ContentItem) -> [Setter] {
            return [
                Self.id <- item.id,
                Self.title <- item.title,
                Self.url <- item.url,
                Self.thumbnail <- item.thumbnail,
                Self.created <- item.created,
                Self.viewed <- item.viewed,
                Self.cached <- item.cached,
                self.contentType <- item.contentType.rawValue
            ]
        }
        
        static func extract(row: Row) throws -> ContentItem {
            return ContentItem(
                id: try row.get(id),
                title: try row.get(title),
                url: try row.get(url),
                thumbnail: try row.get(thumbnail),
                created: try row.get(created),
                viewed: try row.get(viewed),
                cached: try row.get(cached),
                contentType: ContentType(rawValue: try row.get(contentType)) ?? .unknown,
                labels: []
            )
        }
    }
    
    struct ContentLabelTable {
        static let table = Table("content_label")
        static let content_id = Expression<String>("content_id")
        static let label_id = Expression<Int64>("label_id")
        
        static func setters(label: Label, item: ContentItem) -> [Setter] {
            return setters(labelID: label.id, itemID: item.id)
        }
        
        static func setters(labelID: Int64, itemID: String) -> [Setter] {
            return [
                content_id <- itemID,
                label_id <- labelID
            ]
        }
        
        static func create(db: Connection) throws {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(content_id)
                t.column(label_id)
                t.foreignKey(content_id, references: ContentTable.table, ContentTable.id, delete: .noAction)
                t.foreignKey(label_id, references: LabelAccess.LabelTable.table, LabelAccess.LabelTable.id, delete: .noAction)
                t.primaryKey(content_id, label_id)
            })
        }
        
        static func extract(row: Row) throws -> ContentLabel {
            return ContentLabel(
                contentID: try row.get(content_id),
                label: Label(
                    id: try row.get(label_id),
                    name: try row.get(LabelAccess.LabelTable.name)
                )
            )
        }
    }
    
    struct ContentSourceTable {
        static let table = Table("content_source")
        static let content_id = Expression<String>("content_id")
        static let source_id = Expression<Int64>("source_id")
        
        static func setters(source: Source, itemID: String) -> [Setter] {
            return [
                content_id <- itemID,
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
                t.primaryKey(content_id, source_id)
            })
        }
    }
    
}
