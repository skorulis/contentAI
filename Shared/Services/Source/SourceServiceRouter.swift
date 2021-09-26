//
//  SourceService.swift
//  Magic
//
//  Created by Alexander Skorulis on 30/8/21.
//

import Combine
import Foundation

final class SourceServiceRouter: PSourceService, ObservableObject {
    
    let innerService: PSourceService?
    let source: Source
    
    @Published var isLoading: Bool = false
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(source: Source, factory: GenericFactory) {
        self.source = source
        switch source.sourceType {
        case .reddit:
            let reddit = factory.resolve(RedditSourceService.self, argument: source)
            innerService = reddit
            reddit.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { value in
                    self.isLoading = value
                }
                .store(in: &subscribers)
        }
    }
    
    func loadLatest() {
        innerService?.loadLatest()
    }
    
    func loadMore() {
        innerService?.loadMore()
    }
    
    func loadOldest() {
        innerService?.loadOldest()
    }
    
}
