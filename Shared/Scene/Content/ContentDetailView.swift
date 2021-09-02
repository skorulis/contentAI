//
//  ContentDetailView.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/9/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct ContentDetailView {
    
    @StateObject var viewModel: ContentDetailViewModel
    
}

// MARK: - Rendering

extension ContentDetailView: View {
    
    var body: some View {
        VStack {
            if let url = viewModel.content.url {
                WebView(urlString: url)
            } else {
                Text("Missing URL")
            }
            labels
        }
    }
    
    private var labels: some View {
        HStack {
            ForEach(viewModel.labels, id: \.self) { label in
                Button {
                    viewModel.removeLabel(name: label)
                } label: {
                    Text(label)
                        .padding(.horizontal, 4)
                }
            }
            Spacer()
            TextField(
                    "New label",
                     text: $viewModel.labelText
                ) { _ in } onCommit: {
                    viewModel.addLabel()
                }
                .frame(width: 100)
            Button { viewModel.addLabel() } label: {
                Text("Add")
            }
        }
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
    }
}
