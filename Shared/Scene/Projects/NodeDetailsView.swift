//
//  NodeDetailsView.swift
//  NodeDetailsView
//
//  Created by Alexander Skorulis on 13/9/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct NodeDetailsView {
    
    @StateObject var viewModel: NodeDetailsViewModel
}

// MARK: - Rendering

extension NodeDetailsView: View {
    
    var body: some View {
        Text(viewModel.name)
            .id(viewModel.node.id)
        if let filter = viewModel.node.operation as? FilterOperator {
            filterView(op: filter)
        } else if let sources = viewModel.node.operation as? SourceOperator {
            sourceView(op: sources)
        }
    }
    
    private func filterView(op: FilterOperator) -> some View {
        VStack {
            Text("Filter")
        }
    }
    
    private func sourceView(op: SourceOperator) -> some View {
        HStack {
            ForEach(Array(op.sources.indices), id: \.self) { index in
                let source = op.sources[index]
                Button {
                    viewModel.loadSource(source: source)
                } label: {
                    Text("\(source.name)")
                }
            }
        }
    }
}
