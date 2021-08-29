//
//  ProjectAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation

struct ContentSourceAccess {
    
    let database: DatabaseService
}

extension ContentSourceAccess {
    
    func get(id: String) throws -> ContentSource? {
        assert(Thread.current.isMainThread)
        let fetchRequest = ContentSource.fetch()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let context = database.mainContext
        return try context.fetch(fetchRequest).first
    }
}
