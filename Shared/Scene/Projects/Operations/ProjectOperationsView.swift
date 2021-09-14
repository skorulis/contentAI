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
 
    let nodes: [OperatorNode.NodeStatus]
    let onSelect: (OperatorNode) -> Void
}

// MARK: - Rendering

extension ProjectOperationsView: View {
    
    var body: some View {
        ScrollView {
            HStack {
                ForEach(Array(nodes.indices), id: \.self) { index in
                    Button {
                        onSelect(nodes[index].node)
                    } label: {
                        OperationView(node: nodes[index])
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

