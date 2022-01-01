//
//  ContentSourceTable.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/1/22.
//

import Foundation
import SQLite

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
            t.foreignKey(content_id, references: ContentTable.table, ContentTable.id, delete: .noAction)
            t.foreignKey(source_id,
                         references: ContentSourceAccess.SourceTable.table,
                         ContentSourceAccess.SourceTable.id, delete: .noAction
            )
            t.primaryKey(content_id, source_id)
        })
    }
}
