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
    var labels: [String] { get }
}


extension PContent {
    
    var isImage: Bool {
        guard let url = url else { return false }
        return url.hasSuffix("jpg") || url.hasSuffix("jpeg") || url.hasSuffix("png") 
    }
}
