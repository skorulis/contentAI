//
//  ContentPickerView.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ContentPickerView {
    
    let items: [ContentSource]
    let onSelected: (ContentSource) -> ()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
}

// MARK: - Rendering

extension ContentPickerView: View {
    
    var body: some View {
        VStack {
            navBar
            content
        }
    }
    
    private var content: some View {
        ScrollView {
            VStack {
                ForEach(items, id: \.self.id) { source in
                    SwiftUI.Button {
                        onSelected(source)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(source.name)
                    }
                }
            }
        }
    }
    
    private var navBar: some View {
        NavigationBar(
            middle: .text("Edit project"),
            trailing: .imageButton("x.circle.fill", { presentationMode.wrappedValue.dismiss() })
        )
    }
    
}
