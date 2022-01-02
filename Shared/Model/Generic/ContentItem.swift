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
    public var cached: Bool
    public var contentType: ContentType
    public var labels: [SimplifiedContentLabel]
    public var score: Double?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
