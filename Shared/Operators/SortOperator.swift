//
//  SortOperator.swift
//  SortOperator
//
//  Created by Alexander Skorulis on 26/9/21.
//

import Combine
import Foundation
import SQLite

final class SortOperator: POperator {
    var name: String = "Sort"
    
    func query(inputQuery: Table) -> Table {
        return inputQuery
            .order(ContentTable.viewed.asc, ContentTable.created.desc)
    }
    
    func processWaiting(inputQuery: Table) async { }
    
}

