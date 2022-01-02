//
//  ContentScoreTable.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/1/22.
//

import Foundation
import SQLite

struct ContentScoreTable {
    
    static let table = Table("content_score")
    static let content_id = Expression<String>("content_id")
    static let project_id = Expression<String>("project_id")
    static let score = Expression<Double?>("score")
    static let date = Expression<Double>("date")
    
    static func setters(contentID: String, projectID: String, score: Double, date: Date) -> [Setter] {
        return [
            Self.content_id <- contentID,
            Self.project_id <- projectID,
            Self.score <- score,
            Self.date <- date.timeIntervalSince1970
        ]
    }
    
    static func create(db: Connection) throws {
        try db.run(table.create(ifNotExists: true) { t in
            t.column(content_id)
            t.column(project_id)
            t.column(score)
            t.column(date)
            t.foreignKey(content_id, references: ContentTable.table, ContentTable.id, delete: .noAction)
            t.primaryKey(content_id, project_id)
        })
    }
    
    static func extract(row: Row) throws -> ContentScore {
        let dateDouble = try row.get(date)
        return ContentScore(
            contentID: try row.get(content_id),
            projectID: try row.get(project_id),
            score: try row.get(score) ?? 0,
            date: Date(timeIntervalSince1970: dateDouble)
        )
    }
    
}
