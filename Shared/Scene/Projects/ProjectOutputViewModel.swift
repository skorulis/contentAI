//
//  ProjectOutputViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Combine
import Foundation

final class ProjectOutputViewModel: ObservableObject {
    
    let project: Project
    let contentAccess: ContentAccess
    
    @Published var operations: [POperation]
    @Published var inputContent: [PContent] = []
    @Published var activeContent: PContent?
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(project: Project,
         contentAccess: ContentAccess
    ) {
        self.project = project
        self.contentAccess = contentAccess
        operations = [
            SourceOperator(source: project.inputs[0], access: contentAccess),
            FilterOperator()
            ]
        
        for i in 0..<operations.count-1 {
            let input = operations[i]
            for c in input.output {
                operations[i+1].handle(value: c)
            }
        }
        
        self.inputContent = operations.last?.output ?? []
        
    }
    
}
