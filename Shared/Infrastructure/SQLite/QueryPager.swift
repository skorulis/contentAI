//
//  QueryPager.swift
//  Magic
//
//  Created by Alexander Skorulis on 7/9/21.
//

import Foundation
import SQLite

struct QueryPager {
    
    let pageSize: Int = 100
    var count: Int = 0
    let baseQuery: Table
    var loaded: [ContentItem] = []
    let rowMap: (Row) -> ContentItem
    let access: ContentAccess
    
    init(access: ContentAccess, baseQuery: Table, rowMap: @escaping (Row) -> ContentItem) {
        self.access = access
        self.baseQuery = baseQuery
        self.rowMap = rowMap
        self.count = getCount()
        self.loaded = loadPage()
    }
    
    private var db: Connection {
        return access.db.db
    }
    
    private func getCount() -> Int {
        return try! db.scalar(baseQuery.count)
    }
    
    private func loadPage() -> [ContentItem] {
        var content = try! db.prepare(baseQuery).map({ row in
            return try! ContentAccess.ContentTable.extract(row: row)
        })
        
        let ids = content.map { $0.id }
        let labels = Dictionary(grouping: access.allLabels(contentIDs: ids), by: {$0.contentID} )
        
        for i in 0..<content.count {
            let id = content[i].id
            content[i].labels = (labels[id] ?? []).map { $0.label.name }
        }
        
        return content
    }
    
}

