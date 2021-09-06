//
//  ProjectAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation

struct ProjectAccess {
    
    let database: DatabaseService
    let sourceAccess: ContentSourceAccess
    
}

extension ProjectAccess {
    
    var all: [Project] {
        return [
            dummyProject1
        ]
            .compactMap { $0 }
    }
    
    var dummyProject1: Project? {
        guard let source = try! sourceAccess.get(name: "C1") else {
            return nil
        }
        return Project(name: "D1", inputs: [source])
    }
    
}
