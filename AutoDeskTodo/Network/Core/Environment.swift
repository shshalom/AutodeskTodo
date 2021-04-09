//
//  Environment.swift
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.
//

import Foundation

public enum EnvironmentType: String {
    case staging = "dev"
    case production = "production"
}

public protocol Environment {
    var type: EnvironmentType { get set }
    var scheme: String { get set }
    var domain: String { get set }
    //var version: String { get set }
}

extension Environment {
    var baseURL: String {
        return "\(scheme)\(domain)"
    }
}
