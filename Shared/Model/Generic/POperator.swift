//
//  POperator.swift
//  Magic
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation
import Combine
import SQLite

protocol POperator {
    
    var name: String { get }
    
    /// Handle a single piece of content and put it into the output if necessary 
    func process(value: ContentItem) async -> ContentItem?
    
    /// The query to get the content outputed from this operator
    func query(inputQuery: Table) -> Table
    
    /// Process any waiting content
    func processWaiting() async
    
}
