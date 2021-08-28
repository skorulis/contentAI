//
//  HTTPResponseValidator.swift
//  Crypto
//
//  Created by Alexander Skorulis on 26/6/21.
//

import Foundation

enum HTTPResponseStatus {
    case ok
    case error(Error)
}

protocol HTTPResponseValidator {
    
    func validate(data: Data?, response: URLResponse) -> HTTPResponseStatus
    
}

struct HTTPStatusValidator: HTTPResponseValidator {
    
    func validate(data: Data?, response: URLResponse) -> HTTPResponseStatus {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .ok
        }
        if httpResponse.statusCode >= 400 {
            return .error(HTTPStatusError.unexpectedStatus(httpResponse.statusCode))
        }
        return .ok
    }
    
}

