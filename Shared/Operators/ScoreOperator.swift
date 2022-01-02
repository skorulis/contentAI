//
//  ScoreOperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/1/22.
//

import Foundation
import SQLite

final class ScoreOperator: POperator {
    var name: String = "Score"
    
    private let project: Project
    private let access: ContentAccess
    
    init(project: Project,
         access: ContentAccess
    ) {
        self.project = project
        self.access = access
    }
    
    func query(inputQuery: Table) -> Table {
        let scores = ContentScoreTable.table.alias("scores")
        
        return inputQuery
            .join(.leftOuter, scores, on: scores[ContentScoreTable.content_id] == ContentTable.table[ContentTable.id] && ContentScoreTable.project_id == project.id)
    }
    
    func processWaiting(inputQuery: Table) async {
        let missing = query(inputQuery: inputQuery)
            .filter(ContentScoreTable.score == nil)
        
        let items = access.loadContent(query: missing)
        
        print("Need to process \(items.count)")
    }
    
}

