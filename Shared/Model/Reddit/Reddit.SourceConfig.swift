//
//  Reddit.SourceConfig.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 31/8/21.
//

import Foundation

extension Reddit {
    
    struct SourceConfig: Codable {
        var subreddit: String = ""
        var pageinationID: String?
        var paginationTime: Double?
    }
}
