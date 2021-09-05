//
//  ProjectOutputViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation

final class ProjectOutputViewModel: ObservableObject {
    
    let project: Project
    
    @Published var inputContent: [PContent] = []
    @Published var activeContent: PContent?
    
    init(project: Project) {
        self.project = project
        
        inputContent = [] //Array(project.inputs).flatMap { Array($0.content) }
    }
    
    
}
