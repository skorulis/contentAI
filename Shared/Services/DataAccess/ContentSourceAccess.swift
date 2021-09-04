//
//  ProjectAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import CoreData
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
    
    func publisher() -> FetchedResultsControllerPublisher<ContentSource> {
        return FetchedResultsControllerPublisher(fetchedResultsController: fetchController())
    }
    
    func fetchController() -> NSFetchedResultsController<ContentSource> {
        let context = database.mainContext
        let req: NSFetchRequest<ContentSource> = ContentSource.fetch()
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func all() -> [ContentSource] {
        let context = database.mainContext
        let req: NSFetchRequest<ContentSource> = ContentSource.fetch()
        return try! context.fetch(req)
    }
}
