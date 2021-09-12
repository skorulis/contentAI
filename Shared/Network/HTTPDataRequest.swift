//
//  HTTPDataRequest.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 11/9/21.
//

import Foundation

struct HTTPDataRequest: HTTPRequest {
    var endpoint: String
    
    var method: String = "GET"
    
    var body: Data? { return nil }
    
    var headers: [String : String] { return [:] }
    
    var params: [String : String] { return [:] }
    
    var flags: [HTTPRequestFlag] { return [] }
    
    typealias ResponseType = Data
    
    func decode(data: Data, response: URLResponse) throws -> Data {
        return data
    }
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
}
