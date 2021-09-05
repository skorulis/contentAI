//
//  AccountsViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Combine
import Foundation

final class AccountsViewModel: ObservableObject {

    let access: AccountsAccess
    private let client: MagicClient
    
    private var subscribers: Set<AnyCancellable> = []
    
    private let authID: String = UUID().uuidString
    
    @Published var showingRedditAuth: Bool = false
    
    init(access: AccountsAccess,
         client: MagicClient
    ) {
        self.access = access
        self.client = client
    }
    
    var hasAuth: Bool {
        return access.redditAuth != nil
    }
    
    var needsReauth: Bool {
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
    
}



