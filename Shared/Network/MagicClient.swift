//
//  MagicClient.swift
//  Magic
//
//  Created by Alexander Skorulis on 29/8/21.
//

import Foundation

final class MagicClient: HTTPClient {
    
    init(logger: HTTPLogger) {
        super.init(baseURL: nil, logger: logger)
    }
    
}
