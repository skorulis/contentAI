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
        container.autoregister(AccountsAccess.self, initializer: AccountsAccess.init)
        container.autoregister(ContentSourceAccess.self, initializer: ContentSourceAccess.init)
        container.autoregister(ContentAccess.self, initializer: ContentAccess.init)
        container.autoregister(LabelAccess.self, initializer: LabelAccess.init)
        container.autoregister(ProjectAccess.self, initializer: ProjectAccess.init)
    }
    
    private func setupServices() {
        container.autoregister(DatabaseService.self, initializer: DatabaseService.init)
            .inObjectScope(.container)
        container.autoregister(DatabaseService2.self, initializer: DatabaseService2.init)
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
        container.autoregister(AppListViewModel.self, initializer: AppListViewModel.init)
        container.autoregister(NewSourceViewModel.self, argument: NewSourceViewModel.Argument.self, initializer: NewSourceViewModel.init)
        container.autoregister(ContentSourceViewModel.self, argument: ContentSource.self, initializer: ContentSourceViewModel.init)
        container.autoregister(ContentDetailViewModel.self, argument: PContent.self, initializer: ContentDetailViewModel.init)
        
        container.autoregister(EditProjectViewModel.self, argument: EditProjectViewModel.Argument.self, initializer: EditProjectViewModel.init)
        container.autoregister(ProjectOutputViewModel.self, argument: Project.self, initializer: ProjectOutputViewModel.init)
        container.autoregister(AccountsViewModel.self, initializer: AccountsViewModel.init)
    }
    
    func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType? {
        return container.resolve(type)
    }
    
}
