//
//  SourceOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation
import SQLite

final class SourceOperator: POperation {
    
    let source: Source
    let pager: QueryPager<ContentItem>
    
    var name: String { source.name }
    
    var count: Int { pager.loaded.count }
    
    init(source: Source, access: ContentAccess) {
        self.source = source
        let query = access.sourceQuery(source: source)
        pager = QueryPager(db: access.db.db, baseQuery: query, rowMap: { row in
            try! ContentAccess.ContentTable.extract(row: row)
        })
    }
    
}
