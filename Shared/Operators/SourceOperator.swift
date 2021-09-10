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
    let pager: QueryPager<ContentItem>
    
    var name: String { source.name }
    var count: Int { pager.loaded.count }
    
    @Published private var _output: PassthroughSubject<PContent, Never> = .init()
    var output: AnyPublisher<PContent, Never> {
        return _output
            .eraseToAnyPublisher()
    }
    
    init(source: Source, access: ContentAccess) {
        self.source = source
        let query = access.sourceQuery(source: source)
        pager = QueryPager(db: access.db.db, baseQuery: query, rowMap: { row in
            try! ContentAccess.ContentTable.extract(row: row)
        })
    }
    
    func start() {
        for item in pager.loaded {
            _output.send(item)
        }
    }
    
    func handle(value: PContent) -> AnyPublisher<PContent, Never> {
        fatalError("Source should not bee handling")
    }
    
}
