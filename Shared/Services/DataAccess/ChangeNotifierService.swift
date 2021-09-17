//
//  ChangeNotifierService.swift
//  ChangeNotifierService
//
//  Created by Alexander Skorulis on 18/9/21.
//

import Foundation
import Combine

struct ChangeNotifierService {
    
    let sourceChanged = PassthroughSubject<Source, Never>()
    
}
