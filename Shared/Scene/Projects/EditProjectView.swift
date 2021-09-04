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
}

// MARK: - Rendering

extension EditProjectView: View {
    
    var body: some View {
        VStack {
            Text("The first part of projects")
            
            Button(action: save) {
                Text("Save")
            }
        }
        .padding(16)
    }
}

// MARK: - Behaviors

extension EditProjectView {
    
    func save() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Previews

struct EditProjectView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = EditProjectViewModel()
        EditProjectView(viewModel: viewModel)
    }
}

