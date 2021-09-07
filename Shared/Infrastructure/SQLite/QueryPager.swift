//
//  QueryPager.swift
//  Magic
//
//  Created by Alexander Skorulis on 7/9/21.
//

import Foundation
import SQLite

struct QueryPager<Content> {
    
    let baseQuery: QueryType
    let loaded: [Content]
    let rowMap: (Row) -> Content
    
    init(db: Connection, baseQuery: QueryType, rowMap: @escaping (Row) -> Content) {
        self.baseQuery = baseQuery
        self.rowMap = rowMap
        self.loaded = try! db.prepare(baseQuery).map { rowMap($0) }
    }
    
}
