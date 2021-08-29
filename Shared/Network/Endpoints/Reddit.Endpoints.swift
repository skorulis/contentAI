//
//  RedditEndpoints.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

extension Reddit {
    enum Endpoints {
        
        public static let userAgent = "ios:com.skorulis.magic:v0.0.1 (by /u/skorulis)"
        public static let redirect = "magicapp://reddit_auth"
        
        static func auth(code: String) -> HTTPJSONRequest<AuthResponse> {
            let credentials = "\(RedditSecrets.clientId):\(RedditSecrets.secret)"
            let encoded = Data(credentials.utf8).base64EncodedString()
            
            let params = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: Self.redirect)
            ]
            
            let url = "https://www.reddit.com/api/v1/access_token"
            var req = HTTPJSONRequest<AuthResponse>(endpoint: url, formParams: params)
            req.method = "POST"
            req.headers["Authorization"] = "Basic \(encoded)"
            req.headers["User-Agent"] = userAgent
            
            return req
        }
        
        static func refresh(token: String) -> HTTPJSONRequest<AuthResponse> {
            let credentials = "\(RedditSecrets.clientId):\(RedditSecrets.secret)"
            let encoded = Data(credentials.utf8).base64EncodedString()
            
            let params = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: token)
            ]
            
            let url = "https://www.reddit.com/api/v1/access_token"
            var req = HTTPJSONRequest<AuthResponse>(endpoint: url, formParams: params)
            req.method = "POST"
            req.headers["Authorization"] = "Basic \(encoded)"
            req.headers["User-Agent"] = userAgent
            
            return req
        }
        
        static func getData(token: String) -> HTTPJSONRequest<ListingResponse> {
            let url = "https://oauth.reddit.com/hot"
            
            var req = HTTPJSONRequest<ListingResponse>(endpoint: url)
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
}

