//
//  NewProjectView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct NewProjectView {
    
    @StateObject var viewModel: NewProjectViewModel
    
    @EnvironmentObject var factory: GenericFactory
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
}

// MARK: - Rendering

extension NewProjectView: View {
    
    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
            TextField("Source", text: $viewModel.source)
            actions
        }
        .padding(.horizontal, 16)
    }
    
    private var actions: some View {
        HStack {
            Button(action: save) {
                Text("Save")
            }
            
            if viewModel.id != nil {
                Button(action: delete) {
                    Text("Delete")
                }
                
                NavigationLink(destination: projectView) {
                    Text("View")
                }
                
                NavigationLink(destination: Text("TEEST")) {
                    Text("???")
                }
            }
            
        }
    }
    
    private var projectView: some View {
        NavigationLazyView(ProjectView(viewModel: factory.resolve(ProjectViewModel.self, argument: viewModel.loadProject()!)))
    }
}

// MARK: - Behaviours

private extension NewProjectView {
    
    func save() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func delete() {
        viewModel.delete()
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Previews

struct NewProjectView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = NewProjectViewModel(arg: .init(id: nil), access: nil)
        NewProjectView(viewModel: viewModel)
    }
}

