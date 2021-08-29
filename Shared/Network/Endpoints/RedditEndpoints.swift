//
//  RedditEndpoints.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

enum RedditEndpoints {
    
    public static let userAgent = "Trending v0.1"
    public static let redirect = "magicapp://reddit_auth"
    
    static func auth(code: String) -> HTTPJSONRequest<RedditAuthResponse> {
        let credentials = "\(RedditSecrets.clientId):\(RedditSecrets.secret)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        
        let params = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Self.redirect)
        ]
        
        let url = "https://www.reddit.com/api/v1/access_token"
        var req = HTTPJSONRequest<RedditAuthResponse>(endpoint: url, formParams: params)
        req.method = "POST"
        req.headers["Authorization"] = "Basic \(encoded)"
        req.headers["User-Agent"] = userAgent
        
        return req
    }
    
    static func refresh(token: String) -> HTTPJSONRequest<RedditAuthResponse> {
        let credentials = "\(RedditSecrets.clientId):\(RedditSecrets.secret)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        
        let params = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: token)
        ]
        
        let url = "https://www.reddit.com/api/v1/access_token"
        var req = HTTPJSONRequest<RedditAuthResponse>(endpoint: url, formParams: params)
        req.method = "POST"
        req.headers["Authorization"] = "Basic \(encoded)"
        req.headers["User-Agent"] = userAgent
        
        return req
    }
    
    static func getData(token: String) -> HTTPJSONRequest<EmptyResponse> {
        let url = "https://www.reddit.com/hot"
        
        var req = HTTPJSONRequest<EmptyResponse>(endpoint: url)
        req.headers["Authorization"] = "Bearer \(token)"
        req.headers["User-Agent"] = userAgent
        
        return req
    }
    
    static func getMe(token: String) -> HTTPJSONRequest<EmptyResponse> {
        let url = "https://oauth.reddit.com/api/v1/me"
        var req = HTTPJSONRequest<EmptyResponse>(endpoint: url)
        req.headers["Authorization"] = "Bearer \(token)"
        req.headers["User-Agent"] = userAgent
        
        return req
    }
    
}

extension RedditEndpoints {
    
    struct RedditAuthResponse: Codable {
        let access_token: String
        let token_type: String
        let expires_in: TimeInterval
        let scope: String
        var refresh_token: String?
        var expiryTime: TimeInterval?
    }
}
