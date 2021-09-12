//
//  TrainModelOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Foundation
import CoreML
//import CreateML

final class TrainModelOperator: POperation {
    var name: String = "Train model"

    init(factory: GenericFactory) {
        //MLTraining
    }
    
    func process(value: PContent) async -> PContent? {
        return value
    }
    
    
    
}
