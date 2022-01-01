//
//  NewProjectView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct NewSourceView {
    
    @StateObject var viewModel: NewSourceViewModel
    
    @EnvironmentObject var factory: GenericFactory
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
}

// MARK: - Rendering

extension NewSourceView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                Picker("SourceType", selection: $viewModel.type) {
                    ForEach(Source.SourceType.allCases) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Name", text: $viewModel.name)
                if viewModel.type == .reddit {
                    TextField("Subreddit", text: $viewModel.reddit.subreddit)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                actions
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("New Source")
        
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
                
            }
            
        }
    }
    
    private var projectView: some View {
        NavigationLazyView(ContentSourceView(viewModel: factory.resolve(ContentSourceViewModel.self, argument: viewModel.loadSource()!)))
    }
}

// MARK: - Behaviours

private extension NewSourceView {
    
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
        let viewModel = NewSourceViewModel(arg: .init(id: nil), access: nil)
        NewSourceView(viewModel: viewModel)
    }
}

