//
//  OperatorNode.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Combine
import Foundation
import SQLite

actor OperatorNode: Identifiable, Equatable, ObservableObject {
    
    weak var delegate: OperatorNodeDelegate?
    let id: String = UUID().uuidString
    let operation: POperator
    let inputQuery: Table
    @Published var count: Int = 0
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(operation: POperator,
         delegate: OperatorNodeDelegate,
         inputQuery: Table
    ) {
        self.operation = operation
        self.delegate = delegate
        self.inputQuery = inputQuery
        
        self.asyncInit()
    }
    
    private func asyncInit() {
        if let observable = operation as? SourceOperator {
            observable.objectWillChange
                .sink { [unowned self] _ in
                    self.objectWillChange.send()
                }
                .store(in: &subscribers)
        }
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
