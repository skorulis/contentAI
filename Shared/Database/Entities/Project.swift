//
//  Project.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation

// Temporarily not in any database
struct Project {
    
    var name: String
    var inputs: [Source]
}

extension Project: Identifiable {
    var id: String { name }
}
