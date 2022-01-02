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
        
        let setters: [[Setter]] = items.map { ContentTable.setters(item: $0) }
        _ = try? db.db.run(ContentTable.table.insertMany(or: .ignore, setters))
        
        let ids = items.map { $0.id }
        
        insertLabels(items: items)
        
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
        print("Created \(needingLink.count) items")
    }
    
    private func insertLabels(items: [ContentItem]) {
        var labels: Set<String> = []
        items.forEach { meta in
            meta.labels.forEach { label in
                labels.insert(label.name)
            }
        }
        
        let labelEntities = labelAccess.findOrCreate(labels: Array(labels))
        let labelDict = Dictionary(grouping: labelEntities) { $0.name }.mapValues { $0[0] }
        
        let existing = allLabels(contentIDs: items.map { $0.id })
        let existingDict = Dictionary(grouping: existing, by: {$0.contentID})
        
        var toCreate: [ContentLabel] = []
        
        for item in items {
            let labels = existingDict[item.id] ?? []
            for l in item.labels {
                if !labels.contains(where: {$0.label.name == l.name }) {
                    let labelItem = labelDict[l.name]!
                    toCreate.append(ContentLabel(contentID: item.id, label: labelItem))
                }
            }
        }
        
        if toCreate.count > 0 {
            let setters = toCreate.map { ContentLabelTable.setters(labelID: $0.label.id, itemID: $0.contentID, projectID: nil) }
            _ = try! db.db.run(ContentLabelTable.table.insertMany(setters))
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
        return loadContent(query: query)
    }
    
    func loadContent(query: Table) -> [ContentItem] {
        var content = try! db.db.prepare(query).map { try! ContentTable.extract(row: $0) }
        let ids = content.map { $0.id }
        let labels = Dictionary(grouping: allLabels(contentIDs: ids), by: {$0.contentID} )
        
        for i in 0..<content.count {
            let id = content[i].id
            content[i].labels = (labels[id] ?? []).map { $0.simplified }
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
    
    func addLabel(content: inout ContentItem, text: String, projectID: String? = nil) {
        let label = labelAccess.findOrCreate(labels: [text]).first!
        let query = ContentLabelTable.table
            .filter(ContentLabelTable.content_id == content.id)
            .filter(ContentLabelTable.project_id == projectID)
            .filter(ContentLabelTable.label_id == label.id)
            
        let existing = try! db.db.prepare(query).map { $0 }
        if existing.count > 0 {
            return
        }
        
        let setters: [Setter] = ContentLabelTable.setters(labelID: label.id, itemID: content.id, projectID: projectID)
        _ = try! db.db.run(ContentLabelTable.table.insert(setters))
        
        if !content.labelNames.contains(text) {
            content.labels.append(SimplifiedContentLabel(projectID: projectID, name: text, predictionScore: nil))
        }
        ChangeNotifierService.shared.onChange(content: content)
    }
    
    func deleteLabel(contentID: String, text: String, projectID: String?) {
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
    
    func markCached(contentID: String) {
        let query = ContentTable.table
            .filter(ContentTable.id == contentID)
            .update([ContentTable.cached <- true])
        
        try! db.db.run(query)
    }
    
    func allContentLabels(ids: [String]) -> [ContentLabel] {
        let query = ContentLabelTable.table
            .filter(ids.contains(ContentLabelTable.content_id))
        
        return try! db.db.prepare(query).map { try ContentLabelTable.extract(row: $0) }
    }
}

