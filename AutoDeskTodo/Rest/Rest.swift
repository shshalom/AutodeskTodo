//
//  Rest.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation

// NOTE: In Real world project the Rest will be implemented as an external framework with dependency to the Network framework.

class Rest {
    
    internal static var network: Networking!
    private init() {}
    
    public static func setup(networking: Networking = Network(environment: TestEnv())) {
        self.network = networking
    }
    
    typealias Tasks = TasksRouter
}

extension Router {
    public var network: Network {
        return  Rest.network as! Network
    }
}
