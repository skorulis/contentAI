//
//  ProjectAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation

struct ProjectAccess {
    
    let database: DatabaseService
}

extension ProjectAccess {
    
    func get(id: String) throws -> Project? {
        assert(Thread.current.isMainThread)
        let fetchRequest = Project.fetch()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let context = database.mainContext
        return try context.fetch(fetchRequest).first
    }
}
