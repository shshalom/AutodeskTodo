//
//  RequestTask.swift
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.
//

import Foundation

/// Represents an HTTP task.
public enum RequestTask {
    /// A request with no additional data.
    case plain
    /// A request body set with `Encodable` type
    case jsonEncodable(Encodable)
}
