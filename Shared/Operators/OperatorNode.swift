//
//  OperatorNode.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Combine
import Foundation

protocol POperatorNode: AnyObject {
    func buffer(content: [ContentItem]) async
    var operation: POperation { get }
    var id: String { get }
}

actor OperatorNode: POperatorNode, Identifiable, Equatable {
    
    weak var next: POperatorNode?
    weak var delegate: OperatorNodeDelegate?
    let id: String = UUID().uuidString
    let operation: POperation
    var count: Int = 0
    
    var tempBuffer: [ContentItem] = []
    private var timerToken: Cancellable?
    
    init(operation: POperation,
         next: POperatorNode,
         delegate: OperatorNodeDelegate
    ) {
        self.operation = operation
        self.next = next
        self.delegate = delegate
    }
    
    func buffer(content: [ContentItem]) async {
        //await process(content: content)
        Task {
            tempBuffer.append(contentsOf: content)
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.consumeWrapper()
            }
        }
    }
    
    private func process(content: [ContentItem]) async {
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
    
    static func ==(lhs: OperatorNode, rhs: OperatorNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    nonisolated private func consumeWrapper() {
        Task {
            await self.consumeBuffer()
        }
    }
    
    private func consumeBuffer() async {
        if tempBuffer.count == 0 { return }
        let toSend = tempBuffer
        self.tempBuffer = []
        timerToken = nil
        await process(content: toSend)
        self.tempBuffer = []
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
    func statusChanged(id: String, status: OperatorNode.Status)
}
