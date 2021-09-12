//
//  OperatorNode.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Foundation

protocol POperatorNode: AnyObject {
    func buffer(content: [PContent]) async
    var operation: POperation { get }
    var id: String { get }
}

actor OperatorNode: POperatorNode, Identifiable {
    
    weak var next: POperatorNode?
    weak var delegate: OperatorNodeDelegate?
    let id: String = UUID().uuidString
    let operation: POperation
    var count: Int = 0
    
    init(operation: POperation,
         next: POperatorNode,
         delegate: OperatorNodeDelegate
    ) {
        self.operation = operation
        self.next = next
        self.delegate = delegate
    }
    
    func buffer(content: [PContent]) async {
        async {
            await self.process(content: content)
        }
    }
    
    private func process(content: [PContent]) async {
        print("Process \(content.count) in \(operation.name)")
        for element in content {
            if let result = await operation.process(value: element) {
                self.count += 1
                self.delegate?.statusChanged(id: id, status: .init(count: count))
                await next?.buffer(content: [result])
            }
        }
    }
    
    nonisolated var name: String {
        return operation.name
    }
    
}

// MARK: - Inner types

extension OperatorNode {
    
    struct Status {
        let count: Int
    }
    
    struct NodeStatus {
        let node: POperatorNode
        var status: Status
    }
}

protocol OperatorNodeDelegate: AnyObject {
    func statusChanged(id: String, status: OperatorNode.Status)
}
