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
    
    func findOrCreate(labels: [String], context: NSManagedObjectContext) throws -> [Label] {
        let fetch = Label.fetch()
        fetch.predicate = NSPredicate(format: "name IN %@", labels)
        var labelEntities = try context.fetch(fetch)
        let existingNames = labelEntities.map { $0.name }
        let missing = labels.filter { !existingNames.contains($0) }
        for name in missing {
            let label = Label(context: context)
            label.name = name
            labelEntities.append(label)
        }
        
        return labelEntities
    }
    
    func findOrCreate2(labels: [String]) -> [Label2] {
        return labels.map { label in
            let setter = LabelTable.setters(label: label)
            let id = try! db2.db.run(LabelTable.table.insert(or: .replace, setter))
            return Label2(id: id, name: label)
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
