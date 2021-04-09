//
//  Endpoint.swift
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation

public protocol EndPointConvertable {
    var endpoint: Endpoint { get }
}

public class Endpoint {
    
    private var environment: Environment!
    public var method: Method
    public var task: RequestTask
    public var httpHeaderFields: [String: String]?
    public var path: String
    
    /// Main initializer for `Endpoint`.
    public init(path: String = "",
                method: Method = .get,
                task: RequestTask = .plain,
                httpHeaderFields: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.task = task
        self.httpHeaderFields = httpHeaderFields
        
    }
    
    //Appling environment on which the endpoint will be executed
    internal func set(environment: Environment?) -> Endpoint {
        if let environment = environment {
            self.environment = environment
        }
        return self
    }
    
    fileprivate func add(httpHeaderFields headers: [String: String]?) -> [String: String]? {
        guard let unwrappedHeaders = headers, unwrappedHeaders.isEmpty == false else {
            return self.httpHeaderFields
        }
        
        var newHTTPHeaderFields = self.httpHeaderFields ?? [:]
        unwrappedHeaders.forEach { key, value in
            newHTTPHeaderFields[key] = value
        }
        return newHTTPHeaderFields
    }
}

//Constract full endpoint url from provided environment
extension Endpoint {
    public var url: URL {
        return URL(string: self.environment.baseURL)!.appendingPathComponent(self.path)
    }
}

/// Extension for converting an `Endpoint` into a `URLRequest`.
extension Endpoint: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        guard let requestURL = Foundation.URL(string: url.absoluteString) else {
            throw Error.decodeError
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = httpHeaderFields
        
        
        switch task {
        case .plain:
            return request
        case let .jsonEncodable(encodable):
            return try request.encoded(encodable: encodable)
        }
    }
}

/// Required for using `Endpoint` as a key type in a `Dictionary`.
extension Endpoint: Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        guard let request = urlRequest else {
            hasher.combine(url)
            return
        }
        hasher.combine(request)
    }
    
    /// Note: If both Endpoints fail to produce a URLRequest the comparison will
    /// fall back to comparing each Endpoint's hashValue.
    public static func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
        let lhsRequest = lhs.urlRequest
        let rhsRequest = rhs.urlRequest
        if lhsRequest != nil, rhsRequest == nil { return false }
        if lhsRequest == nil, rhsRequest != nil { return false }
        if lhsRequest == nil, rhsRequest == nil { return lhs.hashValue == rhs.hashValue }
        return (lhsRequest == rhsRequest)
    }
}
