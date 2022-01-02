//
//  QueryPager.swift
//  Magic
//
//  Created by Alexander Skorulis on 7/9/21.
//

import Combine
import Foundation
import SQLite

final class QueryPager: ObservableObject {
    
    let pageSize: Int = 100
    var count: Int = 0
    let baseQuery: Table
    @Published var loaded: [ContentItem] = []
    let rowMap: (Row) -> ContentItem
    let access: ContentAccess
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(access: ContentAccess, baseQuery: Table, rowMap: @escaping (Row) -> ContentItem) {
        self.access = access
        self.baseQuery = baseQuery
        self.rowMap = rowMap
        self.count = getCount()
        self.loaded = loadPage()
        
        ChangeNotifierService.shared.contentChanged
            .sink { [unowned self] value in
                guard let index = self.index(id: value.id) else { return }
                loaded[index] = value
            }
            .store(in: &subscribers)
        
    }
    
    private var db: Connection {
        return access.db.db
    }
    
    private func getCount() -> Int {
        return try! db.scalar(baseQuery.count)
    }
    
    private func loadPage() -> [ContentItem] {
        var content = try! db.prepare(baseQuery).map({ row in
            return try! ContentTable.extract(row: row)
        })
        
        let ids = content.map { $0.id }
        let labels = Dictionary(grouping: access.allLabels(contentIDs: ids), by: {$0.contentID} )
        
        for i in 0..<content.count {
            let id = content[i].id
            content[i].labels = (labels[id] ?? []).map { $0.simplified }
        }
        
        return content
    }
    
    func index(id: String) -> Int? {
        return loaded.firstIndex(where: { $0.id == id})
    }
    
}

