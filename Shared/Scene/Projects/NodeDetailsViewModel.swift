//
//  NodeDetailsViewModel.swift
//  NodeDetailsViewModel
//
//  Created by Alexander Skorulis on 13/9/21.
//

import Combine
import Foundation

final class NodeDetailsViewModel: ObservableObject {
    
    @Published var node: OperatorNode
    let factory: GenericFactory
    
    var sourceRouter: SourceServiceRouter?
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(node: OperatorNode,
         factory: GenericFactory
    ) {
        self.node = node
        self.factory = factory
        
        node.objectWillChange
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
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
        sourceRouter?.loadMore()
    }
    
}
