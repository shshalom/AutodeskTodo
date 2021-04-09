//
//  Coordinator.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation

protocol Coordinator: class {
    var identifier: UUID { get }
    func start()
}
