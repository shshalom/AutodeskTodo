//
//  Network.swift
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.
//

import Foundation
public protocol Networking: class {
    func request<ResponseType: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Cancellable
    
    func request(_ endpoint: Endpoint, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable
}

public class Network: NSObject, Networking {
    
    let environment: Environment
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        
        return URLSession(configuration: configuration)
    }()
    
    public required init(environment: Environment) {
        self.environment = environment
    }
    
    public func request<ResponseType: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Cancellable {
        
        let endpoint = endpoint.set(environment: self.environment)
        let request = try! endpoint.asURLRequest()
        
        let cancellableRequest =  self.urlSession.dataTask(with: request) { result in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try Utils.jsonDecoder.decode(ResponseType.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure:
                completion(.failure(.apiError))
            }
        }
        
        cancellableRequest.resume()
        
        return cancellableRequest
    }
    
    public func request(_ endpoint: Endpoint, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
        let endpoint = endpoint.set(environment: self.environment)
        let request = try! endpoint.asURLRequest()
        
        let cancellableRequest =  self.urlSession.dataTask(with: request) { result in
            switch result {
            case .success(let (response, _)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                completion(.success(()))
                
            case .failure:
                completion(.failure(.apiError))
            }
        }
        
        cancellableRequest.resume()
        
        return cancellableRequest
    }
}
