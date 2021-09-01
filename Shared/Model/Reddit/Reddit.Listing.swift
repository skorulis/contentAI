//
//  Reddit.Listing.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

extension Reddit {
 
    struct Listing: Codable {
        let data: ListingData
    }
    
    struct ListingData: Codable {
        let id: String
        let subreddit: String
        let thumbnail: String?
        let created: TimeInterval
        let domain: String?
        let title: String
        let url: String
        let likes: Bool?
        
    }
}
