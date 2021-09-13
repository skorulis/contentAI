//
//  RedditSourceService.swift
//  Magic
//
//  Created by Alexander Skorulis on 30/8/21.
//

import Combine
import Foundation

final class RedditSourceService: PSourceService {
    
    private let source: Source
    private let client: MagicClient
    private let access: ContentAccess
    private let accountAccess: AccountsAccess
    
    init(source: Source,
         client: MagicClient,
         access: ContentAccess,
         accountAccess: AccountsAccess
    ) {
        self.client = client
        self.source = source
        self.access = access
        self.accountAccess = accountAccess
    }
    
    private var subscribers: Set<AnyCancellable> = []
    
    func fetchRedditData() {
        guard let auth: Reddit.AuthResponse = accountAccess.redditAuth else { return }
        let config: Reddit.SourceConfig? = source.configObject()
        let subreddit = config?.subreddit ?? ""
        let token = auth.access_token
        let req = Reddit.Endpoints.getListings(token: token, subreddit: subreddit)
        client.execute(req: req)
            .handleError(ErrorService.shared)
            .receive(on: DispatchQueue.global())
            .map { response -> [ContentItem] in
                return response.data.children.map { listing in
                    var labels: [String] = []
                    switch listing.data.likes {
                    case .some(true): labels.append("upvote")
                    case .some(false): labels.append("downvote")
                    default: break
                    }
                    
                    return ContentItem(
                        id: listing.data.id,
                        title: listing.data.title,
                        url: listing.data.url,
                        thumbnail: listing.data.thumbnail,
                        created: listing.data.created,
                        viewed: false,
                        labels: labels
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
        fetchRedditData()
    }
    
}
