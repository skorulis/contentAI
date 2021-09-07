//
//  ProjectOutputView.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ProjectOutputView {
    
    @StateObject var viewModel: ProjectOutputViewModel
    
    @State private var isEditing: Bool = false
    
    @EnvironmentObject var factory: GenericFactory
}

// MARK: - Rendering

extension ProjectOutputView: View {
    
    var body: some View {
        ZStack {
            VStack {
                buttons
                ProjectOperationsView(operations: viewModel.operations)
                contentList
                Text(viewModel.project.name)
            }
            if let active = viewModel.activeContent {
                detailContainer(content: active)
            }
        }
        .sheet(isPresented: $isEditing) {
            EditProjectView(viewModel: factory.resolve(EditProjectViewModel.self, argument: EditProjectViewModel.Argument(project: viewModel.project)))
        }
        
    }
    
    private var buttons: some View {
        HStack {
            Button(action: {isEditing = true}) {
                Text("Edit")
            }
        }
    }
    
    private var contentList: some View {
        List {
            ForEach(viewModel.inputContent, id: \.self.id) { item in
                ContentSummaryView(item: item) {
                    clicked(item: item)
                }
            }
        }
    }
    
    @ViewBuilder
    private func detailContainer(content: PContent) -> some View {
        ZStack(alignment: .topLeading) {
            ContentDetailView(viewModel: factory.resolve(ContentDetailViewModel.self, argument: content))
            Button(action: {viewModel.activeContent = nil}) {
                Text("Back")
            }
            .keyboardShortcut(KeyEquivalent.leftArrow, modifiers: [])
        }
    }
}

// MARK: - Behaviors
                
extension ProjectOutputView {
    
    func clicked(item: PContent) {
        viewModel.activeContent = item
    }
    
}


// MARK: - Previews

/*struct ProjectOutputView_Previews: PreviewProvider {
    
    static var previews: some View {
        let project = Project(name: "TESET", inputs: [])
        let viewModel = ProjectOutputViewModel(project: project)
        return ProjectOutputView(viewModel: viewModel)
    }
}

*/
