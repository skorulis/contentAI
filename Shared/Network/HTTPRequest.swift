//
//  HTTPRequest.swift
//  Crypto
//
//  Created by Alexander Skorulis on 13/5/21.
//

import Foundation

enum HTTPRequestFlag: Equatable, Identifiable {
    case needsAuth
    case logLevel(HTTPLogger.Level)
    
    var id: String {
        switch self {
        case .needsAuth: return "needsAuth"
        case .logLevel(let level): return "logLevel-\(level.rawValue)"
        }
    }
}

protocol HTTPRequest {
    
    associatedtype ResponseType
    
    var endpoint: String { get }
    var method: String { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var params: [String: String] { get }
    var flags: [HTTPRequestFlag] { get }
    func decode(data: Data, response: URLResponse) throws -> ResponseType
    
}

extension HTTPRequest {
    
    var logLevel: HTTPLogger.Level? {
        for flag in flags {
            if case let HTTPRequestFlag.logLevel(level) = flag {
                return level
            }
        }
        return nil
    }
}
