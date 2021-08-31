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
        switch viewModel.project.sourceType {
        case .website:
            WebView(urlString: viewModel.project.url!)
        case .reddit:
            if viewModel.hasAuth {
                contentList
                //Text("Getting lcos \(viewModel.project.content.count)")
            } else {
                WebView(urlString: viewModel.redditAuthURL)
            }
        }
    }
    
    private var contentList: some View {
        List {
            ForEach(viewModel.availableContent) { item in
                ContentSummaryView(item: item)
            }
        }
    }
    
}
