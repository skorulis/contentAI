//
//  AuthProcessor.swift
//  Magic
//
//  Created by Alexander Skorulis on 1/1/22.
//

import Combine
import Foundation

final class AuthProcessor {
    
    let access: AccountsAccess
    private let client: MagicClient
    
    private var subscribers: Set<AnyCancellable> = []
    
    private let authID: String = UUID().uuidString
    
    init(access: AccountsAccess,
         client: MagicClient
    ) {
        self.access = access
        self.client = client
    }
    
    var needsRedditReauth: Bool {
        guard let auth: Reddit.AuthResponse = access.redditAuth else { return false }
        guard let expiry = auth.expiryTime, expiry < Date().timeIntervalSince1970 - 60 else { return false }
        return true
    }
    
    func reauthReddit() {
        guard let auth: Reddit.AuthResponse = access.redditAuth else { return }
        let token = auth.refresh_token!
        let req = Reddit.Endpoints.refresh(token: token)
        client.execute(req: req)
            .handleError(ErrorService.shared)
            .sink { [unowned self] response in
                var newAuth = response
                newAuth.refresh_token = auth.refresh_token
                newAuth.expiryTime = Date(timeIntervalSinceNow: auth.expires_in).timeIntervalSince1970
                self.access.redditAuth = newAuth
            }
            .store(in: &subscribers)
    }
    
    var redditAuthURL: String {
        let scopes = ["identity", "mysubreddits", "read", "vote"].joined(separator: "%20")
        return "https://www.reddit.com/api/v1/authorize?client_id=\(RedditSecrets.clientId)&response_type=code&state=\(authID)&redirect_uri=\(Reddit.Endpoints.redirect)&duration=permanent&scope=\(scopes)"
    }
    
    func startMonitoring() {
        checkRedditAuth()
        Timer.publish(every: 60, on: .main, in: .default)
            .autoconnect()
            .sink { [unowned self] _ in
                self.checkAllAuth()
            }
            .store(in: &subscribers)
    }
    
    private func checkAllAuth() {
        checkRedditAuth()
    }
    
    private func checkRedditAuth() {
        guard let auth: Reddit.AuthResponse = access.redditAuth else { return }
        guard let expiry = auth.expiryTime, expiry < Date().timeIntervalSince1970 - 5 * 60 else { return }
        reauthReddit()
    }
}
