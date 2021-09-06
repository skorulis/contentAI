//
//  QueryPublisher.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Combine
import SQLite
import Foundation

struct QueryPublisher<Content>: Publisher {
    
    typealias Output = [Content]
    typealias Failure = Never
    
    let baseQuery: QueryType
    let loaded: [Content]
    let rowMap: (Row) -> Content
    
    init(db: Connection, baseQuery: QueryType, rowMap: @escaping (Row) -> Content) {
        self.baseQuery = baseQuery
        self.rowMap = rowMap
        self.loaded = try! db.prepare(baseQuery).map { rowMap($0) }
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Self.Failure, S.Input == Self.Output {
        let subscription = Sub(subscriber: subscriber, data: self.loaded)
        subscriber.receive(subscription: subscription)
    }
    
}

extension QueryPublisher {
    
    private final class Sub<S: Subscriber>: Subscription where S.Input == [Content], S.Failure == Never {

        private var subscriber: S?
        private var data: [Content]
        private var runningDemand: Subscribers.Demand = .max(0)
        private var isFinished = false
        
        init(subscriber: S, data: [Content]) {
            self.subscriber = subscriber
            self.data = data
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard !isFinished else { return }
            guard let subscriber = subscriber else { return }
            subscriber.receive(data)
            runningDemand += demand
        }
        
        func cancel() {
            isFinished = true
        }
        
    }
    
}

final class LimitedSubscriber<Content>: Subscriber {
    
    typealias Input = [Content]
    typealias Failure = Never
    
    var subscription: Subscription?
    var limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        subscription?.request(.max(limit))
        return .max(limit)
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        self.subscription = nil
    }
}

