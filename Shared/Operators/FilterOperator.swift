//
//  FilterOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Combine
import Foundation

final class FilterOperator: POperation {
    var name: String = "Filter"
    
    func process(value: ContentItem) async -> ContentItem? {
        if value.isImage {
            return value
        } else {
            return nil
        }
    }
    
}
