//
//  HTTPJSONRequest.swift
//  Crypto
//
//  Created by Alexander Skorulis on 13/5/21.
//

import Foundation

struct HTTPJSONRequest<ResponseType>: HTTPRequest where ResponseType: Decodable {
    
    var endpoint: String
    var method: String = "GET"
    var body: Data?
    var headers: [String: String] = ["Accept": "application/json"]
    var params: [String: String] = [:]
    var flags: [HTTPRequestFlag] = []
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    init<RequestType: Encodable>(endpoint: String, body: RequestType?) {
        self.endpoint = endpoint
        if let body = body {
            self.body = try! JSONEncoder().encode(body)
            self.headers["Content-Type"] = "application/json"
        }
    }
    
    init(endpoint: String, formParams: [URLQueryItem]) {
        self.endpoint = endpoint
        var urlComponents = URLComponents()
        urlComponents.queryItems = formParams
        self.headers["Content-Type"] = "application/x-www-form-urlencoded"
        self.body = urlComponents.query?.data(using: .utf8)
    }
    
    func decode(data: Data, response: URLResponse) throws -> ResponseType {
        return try JSONDecoder().decode(ResponseType.self, from: data)
    }
}
