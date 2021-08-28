//
//  HTTPClient.swift
//  Crypto
//
//  Created by Alexander Skorulis on 13/5/21.
//

import Combine
import Foundation

class HTTPClient {
    
    private let session: URLSession
    private let baseURL: URL
    private let logger: HTTPLogger
    
    private var subscriber: Set<AnyCancellable> = []
    
    private let responseValidator = HTTPStatusValidator()
    
    init(
        baseURL: String,
        logger: HTTPLogger
    ) {
        self.baseURL = URL(string: baseURL)!
        self.logger = logger
        
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
    }
    
    func execute<R: HTTPRequest>(req: R) -> AnyPublisher<R.ResponseType, Error> {
        var request = toURLRequest(req: req)
        before(request: &request, req: req)
        logger.log(request: request, level: req.logLevel)
        return session
            .dataTaskPublisher(for: request)
            .tryMap { (data, response) -> R.ResponseType in
                self.logger.log(response: response, data: data, level: req.logLevel)
                let status = self.responseValidator.validate(data: data, response: response)
                switch status {
                case .ok:
                    return try req.decode(data: data, response: response)
                case .error(let error):
                    throw error
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    @available(macOS 12.0, iOS 15.0, *)
    func executeAsync<R: HTTPRequest>(req: R) async throws -> R.ResponseType {
        var request = toURLRequest(req: req)
        before(request: &request, req: req)
        logger.log(request: request, level: req.logLevel)
        let (data, response) = try await session.data(for: request, delegate: nil)
        self.logger.log(response: response, data: data, level: req.logLevel)
        let status = self.responseValidator.validate(data: data, response: response)
        switch status {
        case .ok:
            return try req.decode(data: data, response: response)
        case .error(let error):
            throw error
        }
    }
    
    func perform<R: HTTPRequest>(req: R) async throws -> R.ResponseType {
        let semaphore = DispatchSemaphore(value: 0)
        
        var resultOutput: Result<R.ResponseType, Error>?
        
        self.execute(req: req)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    resultOutput = .failure(error)
                    semaphore.signal()
                }
            } receiveValue: { output in
                resultOutput = .success(output)
                semaphore.signal()
            }
            .store(in: &subscriber)
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        switch resultOutput! {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func before<T: HTTPRequest>(request: inout URLRequest, req: T) {}
    
}

private extension HTTPClient {
    
    func toURLRequest<R: HTTPRequest>(req: R) -> URLRequest {
        let url = baseURL.appendingPathComponent(req.endpoint)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if req.params.count > 0 {
            components.queryItems = req.params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = req.method
        request.httpBody = req.body
        request.allHTTPHeaderFields = req.headers
        return request
    }
    
}
