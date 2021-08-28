//
//  HTTPStatusError.swift
//  Crypto
//
//  Created by Alexander Skorulis on 26/6/21.
//

import Foundation

enum HTTPStatusError: Error, LocalizedError {
    
    case unexpectedStatus(Int)
    
    var errorDescription: String? {
        switch self {
        case .unexpectedStatus(let status):
            return "Unexpected status code \(status)"
        }
    }
    
}
