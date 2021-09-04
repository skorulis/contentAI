//
//  ProjectOutputViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation

final class ProjectOutputViewModel: ObservableObject {
    
    let project: Project
    
    init(project: Project) {
        self.project = project
    }
}
