//
//  LabelAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 1/9/21.
//

import Foundation
import SQLite

// MARK: - Memory access

struct LabelAccess {
    let database: DatabaseService
}

// MARK: - Inner logic

extension LabelAccess {
    
    func findOrCreate(labels: [String]) -> [Label] {
        let found = find(labels: labels)
        let names = Set(found.map(\.name))
        let missing = labels.filter { !names.contains($0) }
        
        let created = missing.map { label -> Label in
            let setter = LabelTable.setters(label: label)
            let id = try! database.db.run(LabelTable.table.insert(or: .ignore, setter))
            return Label(id: id, name: label)
        }
        return created + found
    }
    
    func find(labels: [String]) -> [Label] {
        let query = LabelTable.table
            .filter(labels.contains(LabelTable.name))
        let labels = try! database.db.prepare(query).map { row in
            return try LabelTable.extract(row: row)
        }
        return labels
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
        
        static func extract(row: Row) throws -> Label {
            return Label(
                id: try row.get(id),
                name: try row.get(name)
            )
        }
    }
    
}
