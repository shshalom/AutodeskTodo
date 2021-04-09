//
//  EnvTest.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation

struct TestEnv: Environment {
    var type: EnvironmentType = .staging
    var scheme: String = "https://"
    var domain = "todolisthomeassignment.herokuapp.com"
    //var version = ""
}
