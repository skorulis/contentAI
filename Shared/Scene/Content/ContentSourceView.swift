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
            ContentDetailView(
                viewModel: factory.resolve(ContentDetailViewModel.self, argument: content),
                onNext: viewModel.next
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
            ForEach(viewModel.availableContent) { item in
                ContentSummaryView(item: item) {
                    clicked(item: item)
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
