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
    
    var count: Int = 0
    
    var output: [PContent] = []
    
    func handle(value: PContent)  {
        if value.url?.hasSuffix("jpg") == true {
            count += 1
            output.append(value)
        }
    }
    
}
