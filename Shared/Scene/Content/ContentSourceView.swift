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
    
    @EnvironmentObject var factory: GenericFactory
}

// MARK: - Rendering

extension ContentSourceView: View {
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navBar
                list
                    .opacity(viewModel.activeContent == nil ? 1 : 0)
            }
            
            if let active = viewModel.activeContent {
                detailContainer(content: active)
            }
            
            
        }
    }
    
    private var navBar: some View {
        NavigationBar(trailing: .imageButton("pencil.circle.fill", viewModel.edit))
    }
    
    @ViewBuilder
    private func detailContainer(content: ContentItem) -> some View {
        ZStack(alignment: .topLeading) {
            ContentDetailView(
                viewModel: factory.resolve(ContentDetailViewModel.self, argument: content)
            )
            Button(action: {viewModel.activeContent = nil}) {
                Text("Back")
            }
            .keyboardShortcut(KeyEquivalent.leftArrow, modifiers: [])
        }
        .id(content.id)
    }
    
    
    @ViewBuilder
    private var list: some View {
        switch viewModel.source.sourceType {
        case .reddit:
            contentList
        }
    }
    
    private var contentList: some View {
        List {
            if viewModel.isEditing {
                NewSourceView(viewModel: factory.resolve(NewSourceViewModel.self, argument: NewSourceViewModel.Argument(id: viewModel.source.id)))
            }
            ForEach(viewModel.availableContent) { item in
                ContentSummaryView(item: item, project: nil) {
                    clicked(item: item)
                }
            }
        }
    }
    
}

// MARK: - Behaviors
                
extension ContentSourceView {
    
    func clicked(item: ContentItem) {
        viewModel.activeContent = item
    }
    
}
