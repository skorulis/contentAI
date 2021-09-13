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
            dummyProject1,
            dummyProject2
        ]
            .compactMap { $0 }
    }
    
    var dummyProject1: Project? {
        let s1 = try! sourceAccess.get(name: "C1")
        let s2 = try! sourceAccess.get(name: "N1")
        let s3 = try! sourceAccess.get(name: "B1")
        let sources = [s1,s2, s3].compactMap { $0 }
        
        return Project(name: "D1", inputs: sources)
    }
    
    var dummyProject2: Project? {
        let s1 = try! sourceAccess.get(name: "Aww")
        
        let sources = [s1].compactMap { $0 }
        
        return Project(name: "Aww", inputs: sources)
    }
    
}
