//
//  LabelAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 1/9/21.
//

import Foundation
import CoreData

// MARK: - Memory access

struct LabelAccess {
    let database: DatabaseService
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
    
    
}
