//
//  ProjectListView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ProjectListView {
    
    @StateObject var viewModel: ProjectListViewModel
    
    @EnvironmentObject var factory: GenericFactory
    
}

// MARK: - Rendering

extension ProjectListView: View {
    
    var body: some View {
        List {
            Section(header: Text("Sources")) {
                ForEach(viewModel.projects) { proj in
                    NavigationLink(destination: existing(project: proj)) {
                        Text(proj.name)
                    }
                }
                newSourceButton
            }

            Section(header: Text("Accounts")) {
                newAccountButton
            }
            
        }
    }
    
    private var newSourceButton: some View {
        NavigationLink(destination: addProject) {
            Text("New source")
        }
    }
    
    private var newAccountButton: some View {
        NavigationLink(destination: addProject) {
            Text("New account")
        }
    }
    
    private func existing(project: ContentSource) -> some View {
        return NavigationLazyView(
            ContentSourceView(viewModel: factory.resolve(ContentSourceViewModel.self, argument: project))
        )
    }
    
    private var addProject: some View {
        let arg = NewProjectViewModel.Argument(id: nil)
        return NavigationLazyView(
            NewProjectView(viewModel: factory.resolve(NewProjectViewModel.self, argument: arg))
        )
    }
}

// MARK: - Previews

struct ProjectListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ProjectListViewModel(access: nil)
        ProjectListView(viewModel: viewModel)
    }
}

