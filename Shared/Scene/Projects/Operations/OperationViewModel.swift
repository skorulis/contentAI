//
//  OperationViewModel.swift
//  OperationViewModel
//
//  Created by Alexander Skorulis on 26/9/21.
//

import Foundation

@MainActor
final class OperationViewModel: ObservableObject {
    
    let node: OperatorNode
    
    @Published var count: Int = 0
    
    nonisolated init(node: OperatorNode) {
        self.node = node
        Task {
            await setupObservers()
        }
    }
    
    func setupObservers() {
        Task {
            await node.$count
                .receive(on: DispatchQueue.main)
                .assign(to: &$count)
        }
        
    }
    
}
