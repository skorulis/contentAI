//
//  ContentLabel.swift
//  Magic
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Foundation

struct ContentLabel: Equatable {
 
    public var contentID: String
    public var projectID: String?
    public var label: Label
    public var predictionScore: Double?
    
    var simplified: SimplifiedContentLabel {
        return SimplifiedContentLabel(projectID: projectID, name: label.name, predictionScore: predictionScore)
    }
}

struct SimplifiedContentLabel: Equatable {
    
    public var projectID: String?
    public var name: String
    public var predictionScore: Double?
    
}
