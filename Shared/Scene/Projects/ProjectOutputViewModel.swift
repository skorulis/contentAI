//
//  ProjectOutputViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation

final class ProjectOutputViewModel: ObservableObject {
    
    let project: Project
    let contentAccess: ContentAccess
    
    @Published var inputContent: [PContent] = []
    @Published var activeContent: PContent?
    
    init(project: Project,
         contentAccess: ContentAccess
    ) {
        self.project = project
        self.contentAccess = contentAccess
        
        inputContent = [] //Array(project.inputs).flatMap { Array($0.content) }
    }
    
    var operations: [POperation] {
        let input = SourceOperator(source: project.inputs[0], access: contentAccess)
        return [input]
    }
    
    
}
