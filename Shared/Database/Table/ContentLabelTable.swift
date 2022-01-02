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
    static let project_id = Expression<String?>("project_id")
    static let label_id = Expression<Int64>("label_id")
    static let prediction_score = Expression<Double?>("prediction_score")
    
    static func setters(labelID: Int64, itemID: String, projectID: String?) -> [Setter] {
        return [
            Self.content_id <- itemID,
            Self.label_id <- labelID,
            Self.project_id <- projectID
        ]
    }
    
    static func create(db: Connection) throws {
        try db.run(table.create(ifNotExists: true) { t in
            t.column(content_id)
            t.column(project_id)
            t.column(label_id)
            t.column(prediction_score)
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
