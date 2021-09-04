//
//  EditProjectView.swift
//  Magic
//
//  Created by Alexander Skorulis on 3/9/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct EditProjectView {
    
    @StateObject var viewModel: EditProjectViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isPickingSource: Bool = false
}

// MARK: - Rendering

extension EditProjectView: View {
    
    var body: some View {
        VStack {
            navBar
            content
        }
        .sheet(isPresented: $isPickingSource) {
            ContentPickerView(
                items: viewModel.contentOptions,
                onSelected: viewModel.add(source:)
            )
        }   
    }
    
    private var navBar: some View {
        NavigationBar(
            middle: .text("Edit project"),
            trailing: .imageButton("x.circle.fill", { dismiss() })
        )
    }
    
    private var content: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
            Button(action: {isPickingSource = true}) {
                Text("Add source")
            }
            sources
            actions
        }
        .padding(16)
    }
    
    private var sources: some View {
        VStack {
            ForEach(Array(viewModel.inputs)) { source in
                Text("\(source.name)")
            }
        }
    }
    
    private var actions: some View {
        HStack {
            Button(action: save) {
                Text("Save")
            }
        }
    }
}

// MARK: - Behaviors

extension EditProjectView {
    
    func save() {
        viewModel.save()
        
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Previews

struct EditProjectView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = EditProjectViewModel(argument: .init(project: nil), projectAccess: nil, sourceAccess: nil)
        EditProjectView(viewModel: viewModel)
    }
}

