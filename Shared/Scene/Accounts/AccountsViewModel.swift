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
    private let authProcessor: AuthProcessor
    
    private var subscribers: Set<AnyCancellable> = []
    
    @Published var showingRedditAuth: Bool = false
    
    init(access: AccountsAccess,
         client: MagicClient,
         authProcessor: AuthProcessor
    ) {
        self.access = access
        self.client = client
        self.authProcessor = authProcessor
        
        access.objectWillChange
            .sink { [unowned self] _ in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
    }
    
    var hasAuth: Bool {
        return access.redditAuth != nil
    }
    
    var needsRedditReauth: Bool {
        return authProcessor.needsRedditReauth
    }
    
    func reauthReddit() {
        authProcessor.reauthReddit()
    }
    
    var redditAuthURL: String {
        return authProcessor.redditAuthURL
    }
    
}



