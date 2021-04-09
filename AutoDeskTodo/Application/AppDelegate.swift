//
//  AppDelegate.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var appCoordinator: Application.Coordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Setup and initial Rest.
        setupRest()
        
        appCoordinator = Application.Coordinator()
        appCoordinator.start()
        
        return true
    }
    
    func setupRest() {
        Rest.setup()
    }
}
