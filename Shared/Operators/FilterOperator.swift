//
//  FilterOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Combine
import Foundation

struct FilterOperator: POperation {
    var name: String = "Filter"
    
    var count: Int = 0
    
    func start() { }
    
    func handle(value: PContent) -> AnyPublisher<PContent, Never> {
        if value.title?.contains("Victoria") == true {
            return Just(value).eraseToAnyPublisher()
        } else {
            return Empty(completeImmediately: false, outputType: PContent.self, failureType: Never.self)
                .eraseToAnyPublisher()
        }
    }
    
}
