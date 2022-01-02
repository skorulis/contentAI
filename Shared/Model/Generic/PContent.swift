//
//  PContent.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 31/8/21.
//

import Foundation

protocol PContent {
    
    var id: String { get }
    var title: String? { get }
    var url: String? { get }
    var thumbnail: String? { get }
    var created: Double { get }
    var labels: [SimplifiedContentLabel] { get set }
    var viewed: Bool { get }
}


extension PContent {
    
    var isImage: Bool {
        guard let url = url else { return false }
        return url.hasSuffix("jpg") || url.hasSuffix("jpeg") || url.hasSuffix("png") 
    }
    
    func projectLabels(_ projectID: String?) -> [String] {
        return labels.filter { label in
            return label.projectID == projectID || label.projectID == nil
        }
        .map { $0.name }
    }
    
    var labelNames: [String] {
        return labels.map { $0.name }
    }
}
