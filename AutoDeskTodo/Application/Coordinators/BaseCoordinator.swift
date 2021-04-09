//
//  BaseCoordinator.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit

extension Coordinators {
    class Base: NSObject, Coordinator {
        var router: Routable?
        var coordinators = [UUID: Coordinator]()
        var identifier: UUID = UUID()
        
        func start() {
            fatalError("Start method must be implemented")
        }
        
        /// Store the coordinator.
        func add(dependency coordinator: Coordinator) {
            if coordinators[coordinator.identifier] == nil {
                coordinators[coordinator.identifier] = coordinator
            }
        }
        
        func remove(dependency coordinator: Coordinator?) {
            print("coordinators count before: \(coordinators.count)")
            guard let aCoordinator = coordinator, !coordinators.isEmpty else { return }
            coordinators.removeValue(forKey: aCoordinator.identifier)
            print("coordinators count after: \(coordinators.count)")
        }
    }
}
