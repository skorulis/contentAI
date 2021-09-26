//
//  DatabaseService.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation
import SQLite

final class DatabaseService {

    let db: Connection
    
    init() {
        db = try! Connection(Self.dbPath)
        db.trace { print ($0) }
        do {
            try ContentAccess.ContentTable.create(db: db)
            try LabelAccess.LabelTable.create(db: db)
            try ContentSourceAccess.SourceTable.create(db: db)
            try ContentAccess.ContentLabelTable.create(db: db)
            try ContentAccess.ContentSourceTable.create(db: db)
        } catch {
            print("Error \(error)")
        }
    }
    
    
    
    
    static var dbPath: String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let url = documentsDirectory.appendingPathComponent("magic2.sqlite3")
        
        print("DATABASE: \(url.absoluteString )")
        return url.absoluteString
    }
    
}
