//
//  Reddit.AuthResponse.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

extension Reddit {
    
    struct AuthResponse: Codable {
        let access_token: String
        let token_type: String
        let expires_in: TimeInterval
        let scope: String
        var refresh_token: String?
        var expiryTime: TimeInterval?
    }
}
