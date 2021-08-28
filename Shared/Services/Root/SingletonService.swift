//
//  SingletonService.swift
//  Crypto
//
//  Created by Alexander Skorulis on 15/5/21.
//

import Foundation

final class SingletonService {
    
}

extension ErrorService {
    
    static var shared: ErrorService {
        return IOC.shared.container.resolve(ErrorService.self)!
    }
}
