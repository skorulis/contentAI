//
//  NodeDetailsViewModel.swift
//  NodeDetailsViewModel
//
//  Created by Alexander Skorulis on 13/9/21.
//

import Foundation

final class NodeDetailsViewModel: ObservableObject {
    
    let node: POperatorNode
    let factory: GenericFactory
    
    var sourceRouter: SourceServiceRouter?
    
    init(node: POperatorNode,
         factory: GenericFactory
    ) {
        self.node = node
        self.factory = factory
    }
    
}

// MARK: - Inner logic

extension NodeDetailsViewModel {
    
    var name: String {
        return node.operation.name
    }
}

// MARK: - Behaviors

extension NodeDetailsViewModel {
 
    func loadSource(source: Source) {
        self.sourceRouter = factory.resolve(SourceServiceRouter.self, argument: source)
        sourceRouter?.loadOldest()
    }
    
}
