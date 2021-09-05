//
//  ProjectListView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct AppListView {
    
    @StateObject var viewModel: AppListViewModel
    
    @EnvironmentObject private var factory: GenericFactory
    
    @State private var isAddProjectOpen: Bool = false
    
}

// MARK: - Rendering

extension AppListView: View {
    
    var body: some View {
        ZStack {
            list
            overlays
        }
    }
    
    private var list: some View {
        List {
            Section(header: Text("Projects")) {
                ForEach(viewModel.projects) { proj in
                    NavigationLink(destination: existing(project: proj)) {
                        Text(proj.name)
                    }
                }
                newProjectButton
            }
            
            Section(header: Text("Sources")) {
                ForEach(viewModel.sources) { proj in
                    NavigationLink(destination: existing(source: proj)) {
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
    
    private var overlays: some View {
        ZStack {
            Color.clear
                .sheet(isPresented: $isAddProjectOpen) {
                    EditProjectView(viewModel: factory.resolve(EditProjectViewModel.self, argument: EditProjectViewModel.Argument(project: nil)))
                }
        }
    }
    
    private var newSourceButton: some View {
        NavigationLink(destination: addSourceView) {
            Text("New source")
        }
    }
    
    private var newAccountButton: some View {
        NavigationLink(destination: accounts) {
            Text("Accounts")
        }
    }
    
    private var newProjectButton: some View {
        Button(action: addProject) {
            Text("New project")
        }
    }
    
    private func existing(source: Source) -> some View {
        return NavigationLazyView(
            ContentSourceView(viewModel: factory.resolve(ContentSourceViewModel.self, argument: source))
        )
    }
    
    private func existing(project: Project) -> some View {
        return NavigationLazyView(
            ProjectOutputView(viewModel: factory.resolve(ProjectOutputViewModel.self, argument: project))
        )
    }
    
    private var addSourceView: some View {
        let arg = NewSourceViewModel.Argument(id: nil)
        return NavigationLazyView(
            NewSourceView(viewModel: factory.resolve(NewSourceViewModel.self, argument: arg))
        )
    }
    
    private var accounts: some View {
        return NavigationLazyView(
            AccountsView(viewModel: factory.resolve())
        )
    }
}

// MARK: - Behaviors

extension AppListView {
 
    func addProject() {
        self.isAddProjectOpen = true
    }
}

// MARK: - Previews

struct ProjectListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = AppListViewModel(sourceAccess: nil, projectAccess: nil)
        AppListView(viewModel: viewModel)
    }
}

