//
//  ProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import Combine

final class ProjectViewModel: ObservableObject {
    
    let project: ContentSource
    let client: MagicClient
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(project: ContentSource, client: MagicClient) {
        self.project = project
        self.client = client
    }
    
}

extension ProjectViewModel {

    var redditAuthURL: String {
        let scopes = ["identity", "mysubreddits", "read", "vote"].joined(separator: "%20")
        return "https://www.reddit.com/api/v1/authorize?client_id=\(RedditSecrets.clientId)&response_type=code&state=\(project.id)&redirect_uri=\(RedditEndpoints.redirect)&duration=permanent&scope=\(scopes)"
    }
}
