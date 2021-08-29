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
    let access: ContentSourceAccess
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(project: ContentSource, client: MagicClient, access: ContentSourceAccess) {
        self.project = project
        self.client = client
        self.access = access
        
        project.objectWillChange
            .sink { [unowned self] _ in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
        
        if needsReauth {
            reauthReddit()
        } else {
            fetchRedditData()
        }
    }
    
}

extension ProjectViewModel {

    var redditAuthURL: String {
        let scopes = ["identity", "mysubreddits", "read", "vote"].joined(separator: "%20")
        return "https://www.reddit.com/api/v1/authorize?client_id=\(RedditSecrets.clientId)&response_type=code&state=\(project.id)&redirect_uri=\(Reddit.Endpoints.redirect)&duration=permanent&scope=\(scopes)"
    }
    
    var hasAuth: Bool {
        return project.authData != nil
    }
    
    var needsReauth: Bool {
        guard let auth: Reddit.AuthResponse = project.authObject() else { return false }
        guard let expiry = auth.expiryTime, expiry < Date().timeIntervalSince1970 - 60 else { return false }
        return true
    }
    
    func reauthReddit() {
        guard let auth: Reddit.AuthResponse = project.authObject() else { return }
        let token = auth.refresh_token!
        let req = Reddit.Endpoints.refresh(token: token)
        client.execute(req: req)
            .handleError(ErrorService.shared)
            .sink { [unowned self] response in
                var newAuth = response
                newAuth.refresh_token = auth.refresh_token
                newAuth.expiryTime = Date(timeIntervalSinceNow: auth.expires_in).timeIntervalSince1970
                self.project.authData = try! JSONEncoder().encode(newAuth)
                self.access.database.saveToDisk()
            }
            .store(in: &subscribers)
    }
    
    func fetchRedditData() {
        guard let auth: Reddit.AuthResponse = project.authObject() else { return }
        let token = auth.access_token
        let req = Reddit.Endpoints.getData(token: token)
        client.execute(req: req)
            .handleError(ErrorService.shared)
            .sink { [unowned self] response in
                print(response)
            }
            .store(in: &subscribers)
    }
    
    
}
