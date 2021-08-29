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

extension Publisher where Failure == Error {
    
    func handleError(_ handler: ErrorService) -> AnyPublisher<Output, Never> {
        return self.catch { error -> Empty<Output, Never> in
            handler.handle(error: error)
            return Empty(completeImmediately: true, outputType: Output.self, failureType: Never.self)
        }
        .eraseToAnyPublisher()
    }
    
}
