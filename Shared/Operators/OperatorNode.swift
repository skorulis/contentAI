//
//  OperatorNode.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Combine
import Foundation
import SQLite

protocol POperatorNode: AnyObject {
    var operation: POperator { get }
    var id: String { get }
}

actor OperatorNode: POperatorNode, Identifiable, Equatable {
    
    weak var delegate: OperatorNodeDelegate?
    let id: String = UUID().uuidString
    let operation: POperator
    let inputQuery: Table
    var count: Int = 0
    
    init(operation: POperator,
         delegate: OperatorNodeDelegate,
         inputQuery: Table
    ) {
        self.operation = operation
        self.delegate = delegate
        self.inputQuery = inputQuery
    }
    
    nonisolated var name: String {
        return operation.name
    }
    
    static func ==(lhs: OperatorNode, rhs: OperatorNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    nonisolated var outputQuery: Table {
        return operation.query(inputQuery: inputQuery)
    }
    
    func updateCount(access: ContentAccess) {
        self.count = try! access.db.db.scalar(outputQuery.count)
    }
    
}

// MARK: - Inner types

extension OperatorNode {
    
    struct Status {
        let count: Int
    }
    
    struct NodeStatus {
        let node: OperatorNode
        var status: Status
    }
}

protocol OperatorNodeDelegate: AnyObject {
    func statusChanged(id: String, status: OperatorNode.Status) async
}
