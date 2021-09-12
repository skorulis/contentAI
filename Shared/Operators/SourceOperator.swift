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
    
    let source: Source
    //let pager: QueryPager<ContentItem>
    
    var name: String { source.name }
    
    var output: [PContent] = []
    
    init(source: Source, access: ContentAccess) {
        self.source = source
        /*let query = access.sourceQuery(source: source)
        pager = QueryPager(db: access.db.db, baseQuery: query, rowMap: { row in
            try! ContentAccess.ContentTable.extract(row: row)
        })*/
        output = access.sourceItems(source: source)
        
    }
    
    func process(value: PContent) async -> PContent? {
        return value
    }
    
}
