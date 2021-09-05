//
//  ProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import Combine

final class ContentSourceViewModel: ObservableObject {
    
    let source: Source
    let client: MagicClient
    let access: ContentSourceAccess
    let contentAccess: ContentAccess
    let sourceRouter: SourceServiceRouter
    
    private var subscribers: Set<AnyCancellable> = []
    
    @Published var activeContent: PContent?
    
    init(source: Source,
         client: MagicClient,
         access: ContentSourceAccess,
         contentAccess: ContentAccess,
         factory: GenericFactory
    ) {
        self.source = source
        self.client = client
        self.access = access
        self.contentAccess = contentAccess
        self.sourceRouter = factory.resolve(SourceServiceRouter.self, argument: source)
        
        /*project.objectWillChange
            .sink { [unowned self] _ in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
        */
        loadMore()
        
    }
    
}

extension ContentSourceViewModel {
    
    var availableContent: [ContentItem] {
        return contentAccess.sourceItems(source: source)
    }

    
    func loadMore() {
        sourceRouter.loadMore()
    }
    
    
    
    
}
