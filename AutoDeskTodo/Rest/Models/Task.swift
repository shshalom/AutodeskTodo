//
//  Task.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 05/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation

// MARK: - ListElement
struct Task: Codable {
    var completed: Bool
    let url: String
    var id, title: String
}
