//
//  RedditEndpoints.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

enum RedditEndoints {
    
    static func auth(username: String, password: String) -> HTTPJSONRequest<EmptyResponse> {
        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        
        let url = "https://www.reddit.com/api/v1/access_token"
        var req = HTTPJSONRequest<EmptyResponse>(endpoint: url)
        req.method = "POST"
        req.headers["Authorization"] = "Basic \(encoded)"
        
        return req
    }
    
}

extension RedditEndoints {
    
}
