//
//  SortOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Foundation

final class SortOperator {
    
    static func process(items: [PContent]) -> [PContent] {
        return items.sorted { p1, p2 in
            return p1.created < p2.created
        }
    }
    
    
}
