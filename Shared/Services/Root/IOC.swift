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
        
    }
    
    private func setupServices() {
        container.autoregister(DatabaseService.self, initializer: DatabaseService.init)
            .inObjectScope(.container)
    }
    
    private func setupViewModels() {
        
    }
    
    func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType? {
        return container.resolve(type)
    }
    
}
