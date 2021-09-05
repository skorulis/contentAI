//
//  PContentSource.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Combine
import Foundation

protocol PContentSource {
    
    var publisher: Published<[PContent]> { get }
    
}
