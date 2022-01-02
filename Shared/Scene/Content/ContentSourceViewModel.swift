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
    
    @Published var activeContent: ContentItem?
    @Published var isEditing: Bool = false
    
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

// MARK: - Inner logic

extension ContentSourceViewModel {
    
    var availableContent: [ContentItem] {
        return contentAccess.sourceItems(source: source)
    }

    func loadMore() {
        sourceRouter.loadMore()
    }
    
}


// MARK: - Behaviors

extension ContentSourceViewModel {
    
    func next() {
        guard let current = activeContent,
              let index = self.availableContent.firstIndex(where: {$0.id == current.id} ),
              index < availableContent.count - 1
        else { return }
        activeContent = availableContent[index + 1]
        objectWillChange.send()
    }
    
    func previous() {
        guard let current = activeContent,
              let index = self.availableContent.firstIndex(where: {$0.id == current.id} ),
              index > 0
        else { return }
        activeContent = availableContent[index - 1]
        objectWillChange.send()
    }
    
    func edit() {
        self.isEditing.toggle()
    }
}
