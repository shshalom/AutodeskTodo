//
//  Error.swift
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
    case encodeError
    case invalidURL(url: Any)
    // Indicates that Encodable couldn't be encoded into Data
    case encodableMapping(Swift.Error)
    /// Indicates that an `Endpoint` failed to encode the parameters for the `URLRequest`.
    case parameterEncoding(Swift.Error?)
}

