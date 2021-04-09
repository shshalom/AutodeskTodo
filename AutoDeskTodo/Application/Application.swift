//
//  Application.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit

private let test_mode = false

// MARK: - Application Namespace
enum Application {}

extension Application {
    class Coordinator: Coordinators.Base {
        
        var window: UIWindow?
        var authenticated = false
        lazy var navigation = UINavigationController()
        
        init(router: Routable? = nil) {
            super.init()
            self.router = router ?? Router(rootController: self.navigation)
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.backgroundColor = .white
            self.window?.rootViewController = navigation
            
            window?.makeKeyAndVisible()
        }
        
        override func start() {
            !authenticated ? runOnboardingFlow() : runMainFlow()
        }
    }
}

// MARK: - Application Flows
extension Application.Coordinator {
    
    private func runOnboardingFlow() {
        let coordinator = Onboarding.Coordinator(router: router!)
        coordinator.finishFlow  = { [weak self, weak coordinator] in
            self?.remove(dependency: coordinator)
            self?.authenticated = true
            self?.start()
        }
        add(dependency: coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        let coordinator = Main.Coordinator(router: router!)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.authenticated = false
            self?.start()
            self?.remove(dependency: coordinator)
        }
        add(dependency: coordinator)
        coordinator.start()
    }
}
