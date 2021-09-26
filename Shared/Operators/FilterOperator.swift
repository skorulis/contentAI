//
//  FilterOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Combine
import Foundation
import SQLite

final class FilterOperator: POperator {
    var name: String = "Filter"
    
    func process(value: ContentItem) async -> ContentItem? {
        if value.isImage {
            return value
        } else {
            return nil
        }
    }
    
    func query(inputQuery: Table) -> Table {
        return inputQuery
            .filter(ContentAccess.ContentTable.contentType == ContentType.image.rawValue)
    }
    
    func processWaiting() async {
        
    }
    
}
