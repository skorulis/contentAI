//
//  TrainModelOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Foundation
import CoreML
import CreateML

final class TrainModelOperator: POperation {
    var name: String = "Train model"

    init(factory: GenericFactory) {
        //MLImageClassifier(trainingData: <#T##MLImageClassifier.DataSource#>)
    }
    
    func process(value: PContent) async -> PContent? {
        return value
    }
    
    func train(content: [PContent]) throws -> MLJob<MLImageClassifier> {
        var labeledFiles = [String: [URL]]()
        labeledFiles["upvote"] = []
        labeledFiles["downvote"] = []
        for content in content {
            guard let url = PreloadOperation.filename(url: content.url!) else { continue }
            if content.labels.contains("upvote") {
                labeledFiles["upvote"]?.append(url)
            } else if content.labels.contains("downvote") {
                labeledFiles["downvote"]?.append(url)
            }
        }
        
        let data = MLImageClassifier.DataSource.filesByLabel(labeledFiles)
        let job = try MLImageClassifier.train(trainingData: data)
        return job
        
    }
    
    
    
}
