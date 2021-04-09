//
//  Router.swift
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.
//

import Foundation

public protocol Router: EndPointConvertable {
    var network: Network { get }
}

extension Router {
    func request<ResponseType: Decodable>(completion: @escaping (Result<ResponseType, Error>) -> Void) -> Cancellable {
        return network.request(self.endpoint, completion: completion)
    }
    
    func request(completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
        return network.request(self.endpoint, completion: completion)
    }
}
