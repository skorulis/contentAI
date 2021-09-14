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
            return value(item: p1) > value(item: p2)
        }
    }
    
    private static func value(item: PContent) -> Double {
        var output = item.created
        if !item.viewed {
            output += 1000000
        }
        return output
    }
    
    
}
