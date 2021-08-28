//
//  DatabaseService.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import CoreData
import Foundation

class DatabaseService {
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "magic")
        persistentContainer.persistentStoreDescriptions = [storeDescription]
        persistentContainer.loadPersistentStores { (_, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }

                // Optionally enable automatic merging.
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            self.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            }
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var childContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }
    
    func saveToDisk() {
        let context = persistentContainer.viewContext
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    var storeDescription: NSPersistentStoreDescription {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let description = NSPersistentStoreDescription(url: documentsDirectory.appendingPathComponent("magic.sqlite"))
        description.type = NSSQLiteStoreType
        
        print("DATABASE: \(description.url?.absoluteString ?? "-")")
        return description
    }
    
}
