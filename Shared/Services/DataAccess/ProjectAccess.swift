//
//  ProjectAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation
import CoreData

struct ProjectAccess {
    
    let database: DatabaseService
    
}

extension ProjectAccess {
    
    func puublisher() -> FetchedResultsControllerPublisher<Project> {
        let context = database.mainContext
        let req: NSFetchRequest<Project> = Project.fetch()
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return FetchedResultsControllerPublisher(fetchedResultsController: frc)
    }
}
