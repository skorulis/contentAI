//
//  StorageOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Foundation
import OrderedCollections

final class StorageOperator {
    
    private(set) var storage: OrderedSet<ContentItem> = []
    
    func store(value: ContentItem) {
        assert(Thread.current.isMainThread, "Expected to be on the main thread")
        print("Store \(value.id)")
        storage.remove(value)
        let v1 = Self.score(item: value)
        
        let index = storage.firstIndex { i in
            return Self.score(item: i) < v1
        }
        
        if let at = index {
            storage.insert(value, at: at)
        } else {
            storage.insert(value, at: storage.count)
        }
    }
    
    static func score(item: ContentItem) -> Double {
        var output = item.created
        if !item.viewed {
            output += 100000000
        }
        return output
    }
    
    
}
