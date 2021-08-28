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
        container.autoregister(ProjectAccess.self, initializer: ProjectAccess.init)
    }
    
    private func setupServices() {
        container.autoregister(DatabaseService.self, initializer: DatabaseService.init)
            .inObjectScope(.container)
        container.autoregister(ErrorService.self, initializer: ErrorService.init)
    }
    
    private func setupViewModels() {
        container.autoregister(ProjectListViewModel.self, initializer: ProjectListViewModel.init)
        container.autoregister(NewProjectViewModel.self, argument: NewProjectViewModel.Argument.self, initializer: NewProjectViewModel.init)
        container.autoregister(ProjectViewModel.self, argument: Project.self, initializer: ProjectViewModel.init)
    }
    
    func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType? {
        return container.resolve(type)
    }
    
}
