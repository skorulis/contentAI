//
//  AccountsAccess.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation

final class AccountsAccess {
    
    private let defaults = UserDefaults.standard
    
    init() {
        
    }
    
    var redditAuth: Reddit.AuthResponse? {
        get {
            guard let data = defaults.data(forKey: Self.redditKey) else { return nil}
            return try! JSONDecoder().decode(Reddit.AuthResponse.self, from: data)
        }
        set {
            let data = try! JSONEncoder().encode(newValue)
            defaults.set(data, forKey: Self.redditKey)
            defaults.synchronize()
        }
    }
    
    
    private static let redditKey = "redditKey"
    
}
