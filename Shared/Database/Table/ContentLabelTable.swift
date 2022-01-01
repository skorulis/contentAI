//
//  ContentLabelTable.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/1/22.
//

import Foundation
import SQLite

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
