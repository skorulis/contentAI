//
//  ContentTable.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/1/22.
//

import Foundation
import SQLite

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
            id: try row.get(ContentTable.id),
            title: try row.get(title),
            url: try row.get(url),
            thumbnail: try row.get(thumbnail),
            created: try row.get(created),
            viewed: try row.get(viewed),
            cached: try row.get(cached),
            contentType: ContentType(rawValue: try row.get(contentType)) ?? .unknown,
            labels: [],
            score: try? row.get(ContentScoreTable.score)
        )
    }
}
