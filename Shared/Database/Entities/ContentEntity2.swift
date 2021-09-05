//
//  ContentEntity2.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation
import SQLite

struct ContentEntity2 {
    
    public var id: String
    public var title: String?
    public var url: String?
    public var thumbnail: String?
    public var created: Double
    
}

// MARK: - Database

extension ContentEntity2 {
    
    static func create(db: Connection) throws {
        let table = Table("content")
        let id = Expression<String>("id")
        let title = Expression<String?>("title")
        let url = Expression<String?>("url")
        let thumbnail = Expression<String?>("thumbnail")
        let created = Expression<Double>("created")
        
        try db.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(title)
            t.column(url)
            t.column(thumbnail)
            t.column(created)
        })
    }
}
