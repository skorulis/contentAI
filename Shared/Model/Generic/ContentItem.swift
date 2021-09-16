//
//  ContentItem.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

struct ContentItem: PContent, Identifiable, Hashable {
    
    public var id: String
    public var title: String?
    public var url: String?
    public var thumbnail: String?
    public var created: Double
    public var viewed: Bool
    public var labels: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
