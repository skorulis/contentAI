//
//  ErrorService.swift
//  Crypto
//
//  Created by Alexander Skorulis on 15/5/21.
//

import Combine
import Foundation

final class ErrorService {
    
    func handle(error: Error) {
        print(error)
    }
    
}

extension Publisher where Output == Void, Failure == Error {
    
    /*func sink(_ errorService: ErrorService) -> AnyCancellable {
        return sink { (result) in
            switch result {
            case .success: break
            case .failure(let error): errorService.handle(error: error)
            }
        }
    }*/
    
}
