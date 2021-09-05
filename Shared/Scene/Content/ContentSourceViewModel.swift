//
//  ProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import Combine

final class ContentSourceViewModel: ObservableObject {
    
    let project: ContentSource
    let client: MagicClient
    let access: ContentSourceAccess
    let sourceRouter: SourceServiceRouter
    
    private var subscribers: Set<AnyCancellable> = []
    
    @Published var activeContent: PContent?
    
    init(project: ContentSource,
         client: MagicClient,
         access: ContentSourceAccess,
         factory: GenericFactory
    ) {
        self.project = project
        self.client = client
        self.access = access
        self.sourceRouter = factory.resolve(SourceServiceRouter.self, argument: project)
        
        project.objectWillChange
            .sink { [unowned self] _ in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
        
        loadMore()
        
    }
    
}

extension ContentSourceViewModel {
    
    
    
    var availableContent: [ContentEntity] {
        return Array(project.content)
    }

    
    func loadMore() {
        sourceRouter.loadMore()
    }
    
    
    
    
}
