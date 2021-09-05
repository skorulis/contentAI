//
//  DeeplinkService.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Combine
import Foundation

final class DeeplinkService {
    
    private let client: MagicClient
    private let access: AccountsAccess
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(client: MagicClient, access: AccountsAccess) {
        self.client = client
        self.access = access
    }
    
    func onDeeplink(url: URL) {
        guard url.scheme == "magicapp" else {
            return // How did this happen
        }
        if url.host == "reddit_auth" {
            let components = URLComponents(string: url.absoluteString)!
            let code = components.queryItems?.first(where: {$0.name == "code"})?.value
            let id = components.queryItems?.first(where: {$0.name == "state"})?.value
            getRedditToken(id: id!, code: code!)
        }
    }
    
    func getRedditToken(id: String, code: String) {
        let req = Reddit.Endpoints.auth(code: code)
        client.execute(req: req)
            .sink { [unowned self] result in
                switch result {
                case .success(let auth):
                    var newAuth = auth
                    newAuth.expiryTime = Date(timeIntervalSinceNow: auth.expires_in).timeIntervalSince1970
                    self.access.redditAuth = newAuth
                case .failure(let error):
                    ErrorService.shared.handle(error: error)
                }
            }
            .store(in: &subscribers)
    }
    
}
