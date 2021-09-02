//
//  IOC.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation

import Swinject
import SwinjectAutoregistration

public final class IOC {
    
    static let shared: IOC = IOC()
    
    public let container: Container
    
    public init() {
        container = Container()
        setupFactories()
        setupServices()
        setupViewModels()
        setupProcessors()
        setupAccess()
    }
    
    private func setupFactories() {
        container.register(GenericFactory.self) { (_) -> GenericFactory in
            return GenericFactory(container: self.container)
        }
        .inObjectScope(.container)
    }
    
    private func setupProcessors() {
        
    }
    
    private func setupAccess() {
        container.autoregister(ContentSourceAccess.self, initializer: ContentSourceAccess.init)
        container.autoregister(ContentAccess.self, initializer: ContentAccess.init)
        container.autoregister(LabelAccess.self, initializer: LabelAccess.init)
    }
    
    private func setupServices() {
        container.autoregister(DatabaseService.self, initializer: DatabaseService.init)
            .inObjectScope(.container)
        container.autoregister(ErrorService.self, initializer: ErrorService.init)
        container.autoregister(MagicClient.self, initializer: MagicClient.init)
        container.autoregister(HTTPLogger.self, initializer: HTTPLogger.init)
        container.autoregister(DeeplinkService.self, initializer: DeeplinkService.init)
            .inObjectScope(.container)
        
        container.autoregister(SourceServiceRouter.self, argument: ContentSource.self, initializer: SourceServiceRouter.init)
        container.autoregister(RedditSourceService.self, argument: ContentSource.self, initializer: RedditSourceService.init)
    }
    
    private func setupViewModels() {
        container.autoregister(ProjectListViewModel.self, initializer: ProjectListViewModel.init)
        container.autoregister(NewProjectViewModel.self, argument: NewProjectViewModel.Argument.self, initializer: NewProjectViewModel.init)
        container.autoregister(ContentSourceViewModel.self, argument: ContentSource.self, initializer: ContentSourceViewModel.init)
        container.autoregister(ContentDetailViewModel.self, argument: PContent.self, initializer: ContentDetailViewModel.init)
    }
    
    func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType? {
        return container.resolve(type)
    }
    
}
