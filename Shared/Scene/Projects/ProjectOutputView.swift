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
        VStack {
            buttons
            Text(viewModel.project.name)
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
}

// MARK: - Previews

struct ProjectOutputView_Previews: PreviewProvider {
    
    static var previews: some View {
        let project = Project()
        project.name = "TEEST"
        let viewModel = ProjectOutputViewModel(project: project)
        return ProjectOutputView(viewModel: viewModel)
    }
}

