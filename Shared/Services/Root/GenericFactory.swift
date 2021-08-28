//
//  GenericFactory.swift
//  Crypto
//
//  Created by Alexander Skorulis on 16/5/21.
//

import Swinject
import Foundation

final class GenericFactory: ObservableObject {
    
    private let container: Container
    
    init() {
        self.container = Container()
    }
    
    init(container: Container) {
        self.container = container
    }
    
    func resolve<Service>(_ serviceType: Service.Type = Service.self) -> Service {
        guard let service = container.resolve(serviceType) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
    func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        guard let service = container.resolve(serviceType, argument: argument) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
    func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2
    ) -> Service {
        guard let service = container.resolve(serviceType, arguments: arg1, arg2) else {
            fatalError("Could not resolve \(serviceType)")
        }
        return service
    }
    
}
