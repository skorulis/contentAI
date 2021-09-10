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
        
        let source = operations[0] as! SourceOperator
        var output: AnyPublisher<PContent, Never> = source.output
        
        for i in 1..<operations.count {
            output = output.flatMap { [unowned self] value in
                return self.operations[i].handle(value: value)
            }
            .eraseToAnyPublisher()
        }
        
        output
            .sink { [unowned self] c in
                self.inputContent.append(c)
            }
            .store(in: &subscribers)
        
        
        source.start()
    }
    
}
