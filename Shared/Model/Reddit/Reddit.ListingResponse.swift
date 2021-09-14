//
//  Reddit.ListingResponse.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

extension Reddit {
    
    struct ListingResponse: Codable {
        let data: ListingResponseData
    }
    
    struct ListingResponseData: Codable {
        let after: String?
        let children: [Listing]
    }
    
}
