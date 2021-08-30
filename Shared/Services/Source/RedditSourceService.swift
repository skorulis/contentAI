//
//  RedditSourceService.swift
//  Magic
//
//  Created by Alexander Skorulis on 30/8/21.
//

import Combine
import Foundation

final class RedditSourceService: PSourceService {
    
    private let source: ContentSource
    private let client: MagicClient
    private let access: ContentAccess
    
    init(source: ContentSource,
         client: MagicClient,
         access: ContentAccess
    ) {
        self.client = client
        self.source = source
        self.access = access
    }
    
    private var subscribers: Set<AnyCancellable> = []
    
    var hasAuth: Bool {
        return source.authData != nil
    }
    
    var needsReauth: Bool {
        guard let auth: Reddit.AuthResponse = source.authObject() else { return false }
        guard let expiry = auth.expiryTime, expiry < Date().timeIntervalSince1970 - 60 else { return false }
        return true
    }
    
    func reauthReddit() {
        guard let auth: Reddit.AuthResponse = source.authObject() else { return }
        let token = auth.refresh_token!
        let req = Reddit.Endpoints.refresh(token: token)
        client.execute(req: req)
            .handleError(ErrorService.shared)
            .sink { [unowned self] response in
                var newAuth = response
                newAuth.refresh_token = auth.refresh_token
                newAuth.expiryTime = Date(timeIntervalSinceNow: auth.expires_in).timeIntervalSince1970
                self.source.authData = try! JSONEncoder().encode(newAuth)
                self.access.database.saveToDisk()
            }
            .store(in: &subscribers)
    }
    
    func fetchRedditData() {
        guard let auth: Reddit.AuthResponse = source.authObject() else { return }
        let token = auth.access_token
        let req = Reddit.Endpoints.getData(token: token)
        client.execute(req: req)
            .handleError(ErrorService.shared)
            .receive(on: DispatchQueue.global())
            .map { response -> [ContentItem] in
                return response.data.children.map { listing in
                    return ContentItem(
                        id: listing.data.id,
                        title: listing.data.title,
                        url: listing.data.url,
                        thumbnail: listing.data.thumbnail,
                        created: listing.data.created
                    )
                }
            }
            .sink { [unowned self] items in
                self.access.store(items: items, source: self.source)
                //print(response)
            }
            .store(in: &subscribers)
    }
    
    func loadMore() {
        if needsReauth {
            reauthReddit()
        } else {
            fetchRedditData()
        }
    }
    
}
