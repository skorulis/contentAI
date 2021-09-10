//
//  OperationNode.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 9/9/21.
//

import Foundation

final class OperationNode {
    
    let operation: POperation
    
    var input: [PContent] = []
    var output: [PContent] = []
    
    init(operation: POperation) {
        self.operation = operation
    }
    
}
