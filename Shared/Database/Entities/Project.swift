//
//  Project.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation

// Temporarily not in any database
struct Project {
    
    var name: String
    var inputs: [Source]
}

extension Project: Identifiable {
    var id: String { name }
}

// MARK: Logic

extension Project {
    
    func operators(factory: GenericFactory) -> [POperator] {
        let contentAccess = factory.resolve(ContentAccess.self)
        
        if name == "Hot" {
            return [
                SourceOperator(sources: inputs, access: contentAccess),
                FilterOperator(),
                PreloadOperation(factory: factory),
                ScoreOperator(project: self, access: contentAccess),
                SortOperator()
                //TrainModelOperator(factory: factory)
                ]
        } else if name == "Interesting" {
            return [
                SourceOperator(sources: inputs, access: contentAccess),
                //FilterOperator(),
                //PreloadOperation(factory: factory),
                SortOperator()
                //TrainModelOperator(factory: factory)
                ]
        } else {
            return [
                SourceOperator(sources: inputs, access: contentAccess),
                FilterOperator(),
                PreloadOperation(factory: factory),
                SortOperator()
                //TrainModelOperator(factory: factory)
                ]
        }
        
        
    }
    
}
