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
    var count: Int { get }
    
    //var output: AnyPublisher<PContent, Never> { get }
    
    //func start()
    
    func handle(value: PContent) -> AnyPublisher<PContent, Never>
    
}
