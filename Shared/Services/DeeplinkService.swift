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
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(client: MagicClient) {
        self.client = client
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
        let req = RedditEndpoints.auth(code: code)
        client.execute(req: req)
            .sink { result in
                print(result)
            }
            .store(in: &subscribers)
    }
    
}
