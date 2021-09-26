//
//  RedditSourceService.swift
//  Magic
//
//  Created by Alexander Skorulis on 30/8/21.
//

import Combine
import Foundation

final class RedditSourceService: PSourceService, ObservableObject {
    
    @Published var source: Source 
    private let client: MagicClient
    private let sourceAccess: ContentSourceAccess
    private let access: ContentAccess
    private let accountAccess: AccountsAccess
    
    @Published var isLoading: Bool = false
    
    init(source: Source,
         client: MagicClient,
         sourceAccess: ContentSourceAccess,
         access: ContentAccess,
         accountAccess: AccountsAccess
    ) {
        self.client = client
        self.source = source
        self.sourceAccess = sourceAccess
        self.access = access
        self.accountAccess = accountAccess
        
        ChangeNotifierService.shared.sourceChanged
            .filter { $0.id == source.id}
            .assign(to: &$source)
        
    }
    
    private var subscribers: Set<AnyCancellable> = []
    
    func fetchRedditData(before: String? = nil, after: String? = nil, storePage: Bool ) {
        guard let auth: Reddit.AuthResponse = accountAccess.redditAuth else { return }
        let config: Reddit.SourceConfig? = source.configObject()
        let subreddit = config?.subreddit ?? ""
        let token = auth.access_token
        let req = Reddit.Endpoints.getListings(token: token, subreddit: subreddit, before: before, after: after)
        isLoading = true
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
                    
                    labels.append(listing.data.subreddit)
                    
                    return ContentItem(
                        id: listing.data.id,
                        title: listing.data.title,
                        url: listing.data.url,
                        thumbnail: listing.data.thumbnail,
                        created: listing.data.created,
                        viewed: false,
                        cached: false,
                        contentType: ContentType.unchecked,
                        labels: labels
                    )
                }
            }
            .sink { [unowned self] items in
                self.access.store(items: items, source: self.source)
                var config: Reddit.SourceConfig? = source.configObject()
                if let last = items.last, storePage {
                    config?.pageinationID = last.id
                    config?.paginationTime = last.created
                    let date = Date(timeIntervalSince1970: last.created)
                    print("Updated pagination \(last.id): \(date)")
                } else {
                    config?.pageinationID = nil
                    config?.paginationTime = nil
                }
                var mutableSource = source
                mutableSource.setConfigObject(obj: config)
                _ = sourceAccess.save(source: mutableSource)
                //print(response)
                self.isLoading = false
            }
            .store(in: &subscribers)
    }
    
    func loadMore() {
        guard let config: Reddit.SourceConfig? = source.configObject(), let id = config?.pageinationID else {
            loadLatest()
            return
        }
        fetchRedditData(after: "t3_\(id)", storePage: true)
    }
    
    func loadLatest() {
        fetchRedditData(storePage: true)
    }
    
    func loadOldest() {
        var query = access.sourceQuery(sources: [source])
        query = query
            .order(ContentAccess.ContentTable.created.asc)
            .limit(1)
        
        guard let oldest = try! access.db.db.prepare(query)
                .map({ try ContentAccess.ContentTable.extract(row: $0) })
                .first else {
            return
        }
        fetchRedditData(after: "t3_\(oldest.id)", storePage: false)
    }
    
    
}
