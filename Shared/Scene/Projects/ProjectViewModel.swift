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
        test()
    }
    
}

extension ProjectViewModel {
    
    func test() {
        let req = RedditEndoints.auth(username: RedditSecrets.clientId, password: RedditSecrets.secret)
        self.client.execute(req: req)
            .sink { result in
                print(result)
            }
            .store(in: &subscribers)
    }
    
}
