//
//  SourceOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation
import SQLite
import Combine

final class SourceOperator: POperation {
    
    let sources: [Source]
    //let pager: QueryPager<ContentItem>
    
    var name: String {
        if sources.count == 1 {
            return sources[0].name
        } else {
            return "\(sources.count) sources"
        }
    }
    
    var output: [ContentItem] = []
    
    init(sources: [Source], access: ContentAccess) {
        self.sources = sources
        /*let query = access.sourceQuery(source: source)
        pager = QueryPager(db: access.db.db, baseQuery: query, rowMap: { row in
            try! ContentAccess.ContentTable.extract(row: row)
        })*/
        
        output = sources.flatMap { s in
            return access.sourceItems(source: s)
        }
    }
    
    func process(value: ContentItem) async -> ContentItem? {
        return value
    }
    
}
