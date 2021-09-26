//
//  ProjectSectionsView.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct ProjectOperationsView {
 
    let nodes: [OperatorNode]
    let onSelect: (OperatorNode) -> Void
    
    @EnvironmentObject var factory: GenericFactory
}

// MARK: - Rendering

extension ProjectOperationsView: View {
    
    var body: some View {
        ScrollView {
            HStack {
                ForEach(Array(nodes.indices), id: \.self) { index in
                    Button {
                        onSelect(nodes[index])
                    } label: {
                        OperationView(viewModel: factory.resolve(OperationViewModel.self, argument: nodes[index]))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Previews

struct ProjectSectionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProjectOperationsView(nodes: [], onSelect: { _ in })
    }
}

