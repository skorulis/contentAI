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
        VStack(spacing: 0) {
            if let urlString = viewModel.content.url, let url = URL(string: urlString) {
                if viewModel.content.isImage {
                    plainImage(url: url)
                } else {
                    WebView(urlString: urlString)
                }
            } else {
                Text("Missing URL")
            }
            labels
        }
    }
    
    private func plainImage(url: URL) -> some View {
        ZStack {
            Color.gray
            if PreloadOperation.hasPreloaded(url: url.absoluteString) {
                preloadedImage(url: url)
            } else {
                asynImage(url: url)
            }
        }
    }
    
    @ViewBuilder
    private func preloadedImage(url: URL) -> some View {
        if let filename = PreloadOperation.filename(url: url.absoluteString),
           let image = UIImage(contentsOfFile: filename.path)
        {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Text("PREL")
        }
        
        
    }
    
    private func asynImage(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                
        } placeholder: {
            ProgressView()
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
        .background(Color.white)
    }
}
