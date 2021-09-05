//
//  DatabaseService2.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation
import SQLite

final class DatabaseService2 {
    
    init() {
        do {
            let db = try Connection(dbPath)
            try ContentEntity2.create(db: db)
        } catch {
            print("Error \(error)")
        }
        
        
    }
    
    
    var dbPath: String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let url = documentsDirectory.appendingPathComponent("magic2.sqlite3")
        
        print("DATABASE: \(url.absoluteString ?? "-")")
        return url.absoluteString
    }
    
}
