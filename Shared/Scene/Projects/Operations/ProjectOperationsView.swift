//
//  ProjectSectionsView.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct ProjectOperationsView {
 
    let operations: [POperation]
}

// MARK: - Rendering

extension ProjectOperationsView: View {
    
    var body: some View {
        ScrollView {
            HStack {
                ForEach(Array(operations.indices), id: \.self) { index in
                    OperationView(operation: operations[index])
                }
            }
        }
    }
}

// MARK: - Previews

struct ProjectSectionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProjectOperationsView(operations: [])
    }
}

