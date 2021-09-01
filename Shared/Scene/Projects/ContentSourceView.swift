//
//  ProjectView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import SwiftUI

// MARK: - Memory footprint

struct ContentSourceView {
    
    @StateObject var viewModel: ContentSourceViewModel
}

// MARK: - Rendering

extension ContentSourceView: View {
    
    var body: some View {
        ZStack {
            list
                .opacity(viewModel.activeContent == nil ? 1 : 0)
            if let active = viewModel.activeContent {
                detailContainer(content: active)
            }
        }
    }
    
    @ViewBuilder
    private func detailContainer(content: PContent) -> some View {
        ZStack(alignment: .topLeading) {
            detail(content: content)
            Button(action: {viewModel.activeContent = nil}) {
                Text("Back")
            }
            .keyboardShortcut(KeyEquivalent.leftArrow, modifiers: [])
        }
    }
    
    @ViewBuilder
    private func detail(content: PContent) -> some View {
        if let url = content.url {
            WebView(urlString: url)
        } else {
            Text("Missing URL")
        }
    }
    
    
    @ViewBuilder
    private var list: some View {
        switch viewModel.project.sourceType {
        case .website:
            WebView(urlString: viewModel.project.url!)
        case .reddit:
            if viewModel.hasAuth {
                contentList
            } else {
                WebView(urlString: viewModel.redditAuthURL)
            }
        }
    }
    
    private var contentList: some View {
        List {
            ForEach(viewModel.availableContent) { item in
                Button(action: { clicked(item: item) }) {
                    ContentSummaryView(item: item)
                }
            }
        }
    }
    
}

// MARK: - Behaviors
                
extension ContentSourceView {
    
    func clicked(item: PContent) {
        viewModel.activeContent = item
    }
    
}
