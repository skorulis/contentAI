//
//  SourceOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation
import SQLite
import Combine

final class SourceOperator: POperator {
    
    let sources: [Source]
    let access: ContentAccess
    
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
        self.access = access
        
        output = sources.flatMap { s in
            return access.sourceItems(source: s)
        }
    }
    
    func process(value: ContentItem) async -> ContentItem? {
        return value
    }
    
    func query(inputQuery: Table?) -> Table {
        return access.sourceQuery(sources: sources)
    }
    
}
