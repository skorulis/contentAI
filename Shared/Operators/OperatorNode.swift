//
//  OperatorNode.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Combine
import Foundation

protocol POperatorNode: AnyObject {
    func buffer(content: [PContent]) async
    var operation: POperation { get }
    var id: String { get }
}

actor OperatorNode: POperatorNode, Identifiable, Equatable {
    
    weak var next: POperatorNode?
    weak var delegate: OperatorNodeDelegate?
    let id: String = UUID().uuidString
    let operation: POperation
    var count: Int = 0
    
    var tempBuffer: [PContent] = []
    private var timerToken: Cancellable?
    
    init(operation: POperation,
         next: POperatorNode,
         delegate: OperatorNodeDelegate
    ) {
        self.operation = operation
        self.next = next
        self.delegate = delegate
    }
    
    func buffer(content: [PContent]) async {
        Task {
            tempBuffer.append(contentsOf: content)
            let runLoop = RunLoop.main
            timerToken = RunLoop.main.schedule(after: runLoop.now, interval: .seconds(1)) { [weak self] in
                self?.consumeWrapper()
            }
        }
    }
    
    private func process(content: [PContent]) async {
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
        timerToken = nil
        await process(content: tempBuffer)
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
