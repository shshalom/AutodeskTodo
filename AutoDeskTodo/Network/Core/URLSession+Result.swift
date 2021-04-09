//
//  URLSession+Result.swift
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.
//

import Foundation

extension URLSession {
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Swift.Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            result(.success((response, data)))
        }
    }
}
