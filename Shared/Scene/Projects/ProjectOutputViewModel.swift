//
//  ProjectOutputViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Combine
import Foundation

final class ProjectOutputViewModel: ObservableObject, POperatorNode {
    
    let project: Project
    let contentAccess: ContentAccess
    
    @Published var operations: [POperation]
    @Published var operationNodes: [OperatorNode.NodeStatus] = []
    @Published var displayContent: [PContent] = []
    @Published var activeContent: PContent?
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(project: Project,
         contentAccess: ContentAccess,
         factory: GenericFactory
    ) {
        self.project = project
        self.contentAccess = contentAccess
        operations = [
            SourceOperator(source: project.inputs[0], access: contentAccess),
            FilterOperator(),
            PreloadOperation(factory: factory),
            TrainModelOperator(factory: factory)
            ]
        operationNodes = buildProcesss()
        
        async {
            await loadAll()
        }
        
    }
    
    func buildProcesss() -> [OperatorNode.NodeStatus] {
        var nodes = [POperatorNode]()
        var last: POperatorNode = self
        for i in (0..<operations.count).reversed() {
            let node = OperatorNode(operation: operations[i], next: last, delegate: self)
            last = node
            nodes.append(node)
        }
        return nodes.reversed().map { node in
            return OperatorNode.NodeStatus(node: node, status: .init(count: 0))
        }
    }
    
    func loadAll() async {
        let source = operations[0] as! SourceOperator
        await operationNodes[0].node.buffer(content: source.output)
    }
    
    func buffer(content: [PContent]) async {
        DispatchQueue.main.async {
            self.displayContent.append(contentsOf: content)
        }
    }
    
    var operation: POperation {
        fatalError("Not supported here")
    }
    
    var id: String {
        return ""
    }
    
}

// MARK: - Behaviors

extension ProjectOutputViewModel {
    
    func next() {
        guard let current = activeContent,
              let index = self.displayContent.firstIndex(where: {$0.id == current.id} ),
              index < displayContent.count - 1
        else { return }
        activeContent = displayContent[index + 1]
        objectWillChange.send()
    }
    
}

// MARK: - OperatorNodeDelegate

extension ProjectOutputViewModel: OperatorNodeDelegate {
    
    func statusChanged(id: String, status: OperatorNode.Status) {
        DispatchQueue.main.async {
            guard let index = self.operationNodes.firstIndex(where: {$0.node.id == id} ) else { return }
            self.operationNodes[index].status = status
        }
    }
}

