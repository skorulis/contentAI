//
//  Source2.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation

struct Source {
    
    let id: Int64
    let name: String
    let sourceType: SourceType
    var config: Data?
    
    func configObject<T: Decodable>() -> T? {
        guard let data = config else { return nil }
        return try! JSONDecoder().decode(T.self, from: data)
    }

    
}

// MARK: - Inner types

extension Source: Identifiable {
    
    enum SourceType: String, Identifiable, CaseIterable {
        case reddit
        
        var id: String { rawValue }
        
    }
    
}
