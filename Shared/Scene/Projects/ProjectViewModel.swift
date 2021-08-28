//
//  ProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation

final class ProjectViewModel: ObservableObject {
    
    let project: Project
    
    init(project: Project) {
        self.project = project
    }
    
}
