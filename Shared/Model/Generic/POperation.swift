//
//  POperation.swift
//  Magic
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation
import Combine

protocol POperation {
    
    var name: String { get }
    
    /// Handle a single piece of content and put it into the output if necessary 
    func process(value: ContentItem) async -> ContentItem?
    
}
