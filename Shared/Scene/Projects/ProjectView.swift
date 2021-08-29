//
//  ProjectView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import SwiftUI

// MARK: - Memory footprint

struct ProjectView {
    
    @StateObject var viewModel: ProjectViewModel
}

// MARK: - Rendering

extension ProjectView: View {
    
    var body: some View {
        switch viewModel.project.sourceType {
        case .website:
            WebView(urlString: viewModel.project.url!)
        case .reddit:
            if viewModel.hasAuth {
                Text("Getting lcos")
            } else {
                WebView(urlString: viewModel.redditAuthURL)
            }
        }
    }
    
}
