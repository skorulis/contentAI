//
//  LabelAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 1/9/21.
//

import Foundation
import CoreData
import SQLite

// MARK: - Memory access

struct LabelAccess {
    let database: DatabaseService
    let db2: DatabaseService2
}

// MARK: - Inner logic

extension LabelAccess {
    
    func findOrCreate(labels: [String]) -> [Label] {
        return labels.map { label in
            let setter = LabelTable.setters(label: label)
            let id = try! db2.db.run(LabelTable.table.insert(or: .replace, setter))
            return Label(id: id, name: label)
        }
    }
    
}

extension LabelAccess {
    
    struct LabelTable {
        static let table = Table("label")
        static let id = Expression<Int64>("id")
        static let name = Expression<String>("name")
        
        static func create(db: Connection) throws {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name, unique: true)
            })
        }
        
        static func setters(label: String) -> [Setter] {
            return [
                Self.name <- label
            ]
        }
    }
    
}
