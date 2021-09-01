//
//  Publisher+Extension.swift
//  VoidShaperClient
//
//  Created by Alexander Skorulis on 17/7/21.
//

import Combine
import Foundation

extension Publisher {
    
    func afterChange() -> Publishers.Debounce<Self, DispatchQueue> {
        return debounce(for: .zero, scheduler: DispatchQueue.main)
    }
    
    func sink(result: @escaping (Result<Self.Output, Self.Failure>) -> Void) -> AnyCancellable {
        sink { (completion) in
            switch completion {
            case .finished: break
            case .failure(let error): result(.failure(error))
            }
        } receiveValue: { output in
            result(.success(output))
        }

    }
}
