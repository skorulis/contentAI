//
//  ContentAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

// MARK: - Memory access

struct ContentAccess {
    
    let database: DatabaseService
    let labelAccess: LabelAccess
}

extension ContentAccess {
    
    func store(items: [ContentItem], source: ContentSource) {
        let context = database.childContext
        var labels: Set<String> = []
        items.forEach { meta in
            meta.labels.forEach { name in
                labels.insert(name)
            }
        }
        
        context.perform {
            let labelEntities = try! labelAccess.findOrCreate(labels: Array(labels), context: context)
            let labelDict = Dictionary(grouping: labelEntities) { $0.name }.mapValues { $0[0] }
            let contextSource = context.object(with: source.objectID) as! ContentSource
            let ids = items.map { $0.id }
            let fetch = ContentEntity.fetch()
            fetch.predicate = NSPredicate(format: "id IN %@", ids)
            
            let existing = try! context.fetch(fetch)
            let existingIDs = existing.map { $0.id }
            let toCreate = items.filter { !existingIDs.contains($0.id) }
            toCreate.forEach { item in
                let entity = ContentEntity(context: context)
                entity.id = item.id
                entity.title = item.title
                entity.created = item.created
                entity.thumbnail = item.thumbnail
                entity.url = item.url
                entity.sources.insert(contextSource)
                
                for label in item.labels {
                    entity.labelEntities.insert(labelDict[label]!)
                }
                
            }
            try! context.save()
            self.database.saveToDisk()
        }
    }
    
    
}
