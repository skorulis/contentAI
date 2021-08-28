//
//  ManagedObjectChangePublisher.swift
//  Crypto
//
//  Created by Alexander Skorulis on 31/5/21.
//

import Combine
import CoreData
import Foundation

final class ManagedObjectChangePublisher<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    private let internalFRC: NSFetchedResultsController<T>
    
    let publisher: PassthroughSubject<T, Never> = .init()
    
    init(object: T) {
        let fetch = NSFetchRequest<T>(entityName: T.entity().name!)
        fetch.predicate = NSPredicate(format: "self == %@", object.objectID)
        fetch.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: true)]    
        internalFRC = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: object.managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        internalFRC.delegate = self
        try! internalFRC.performFetch()
    }
    
    @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let first = controller.fetchedObjects?.first {
            publisher.send(first as! T)
        }
    }
    
}
