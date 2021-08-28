//
//  ProjectView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import SwiftUI

// MARK: - Memory footprint

struct ProjectView {
    
    @StateObject var viewModel: ProjectViewModel
}

// MARK: - Rendering

extension ProjectView: View {
    
    var body: some View {
        Text("Here's a project")
    }
}
