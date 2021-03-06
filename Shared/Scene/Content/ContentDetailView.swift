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
            ZStack(alignment: .bottomTrailing) {
                mainContent
                rightButtons
            }
            labels
        }
        .onAppear(perform: viewModel.markViewed)
    }
    
    private var rightButtons: some View {
        VStack {
            navButtons
            
            
            Spacer()
            Button {
                viewModel.addLabel(text: "upvote")
                viewModel.removeLabel(name: "downvote")
            } label: {
                Image(systemName: viewModel.isUpvoted ? "arrow.up.square.fill" : "arrow.up.square")
                    .resizable()
                    .frame(width: 44, height: 44)
            }
            .keyboardShortcut("u", modifiers: [])
            .buttonStyle(.plain)
            
            
            Button {
                viewModel.addLabel(text: "downvote")
                viewModel.removeLabel(name: "upvote")
            } label: {
                Image(systemName: viewModel.isDownvoted ? "arrow.down.square.fill" : "arrow.down.square")
                    .resizable()
                    .frame(width: 44, height: 44)
            }
            .keyboardShortcut("d", modifiers: [])
            .buttonStyle(.plain)
            
        }
        .padding(20)
    }
    
    private var navButtons: some View {
        HStack {
            Button(action: viewModel.onPrevious) {
                Image(systemName: "arrow.left.square.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
            }
            .keyboardShortcut("b", modifiers: [])
            .buttonStyle(.plain)
            
            Button(action: viewModel.onNext) {
                Image(systemName: "arrow.right.square.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
            }
            .keyboardShortcut("n", modifiers: [])
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        if let urlString = viewModel.content.url, let url = URL(string: urlString) {
            if viewModel.content.isImage {
                plainImage(url: url)
            } else {
                WebView(urlString: urlString)
            }
        } else {
            Text("Missing URL")
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
           let image = NativeImage(contentsOfFile: filename.path)
        {
            Image(nativeImage: image)
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
            Button {
                viewModel.addingLabel = true
            } label: {
                Image(systemName: "plus.circle.fill")
            }
            .popover(isPresented: $viewModel.addingLabel) {
                addLabelView
            }
            
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color.white)
    }
    
    private var addLabelView: some View {
        VStack {
            Text("Add label")
                .font(.title)
            
            TextField(
                    "New label",
                     text: $viewModel.labelText
                ) { _ in } onCommit: {
                    viewModel.addLabel()
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(width: 100)
            
            Toggle(isOn: $viewModel.globalLabel) {
                Text("Global label")
            }
            
            Button { viewModel.addLabel() } label: {
                Text("Add")
            }
            
        }
        .padding()
    }
}
