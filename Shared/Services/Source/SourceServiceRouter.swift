//
//  SourceService.swift
//  Magic
//
//  Created by Alexander Skorulis on 30/8/21.
//

import Foundation

final class SourceServiceRouter: PSourceService {
    
    let innerService: PSourceService?
    
    init(source: ContentSource, factory: GenericFactory) {
        switch source.sourceType {
        case .reddit:
            innerService = factory.resolve(RedditSourceService.self, argument: source)
        case .website:
            innerService = nil // Not yet implemented
        }
    }
    
    func loadMore() {
        innerService?.loadMore()
    }
    
}
