//
//  TasksRouter.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation

enum TasksRouter: Router {
    case tasks
    case update(task: Task)
    case new(taskTitle: String)
    case delete(taskId: String)
}

extension TasksRouter {
    var endpoint: Endpoint {
        switch self {
        case .tasks: return Endpoint()
        case let .update(task): return Endpoint(path: "\(task.id)", method: .patch, task: .jsonEncodable(task))
        case let .new(taskTitle): return Endpoint(method: .post, task: .jsonEncodable(["title": taskTitle]))
        case let .delete(taskId): return Endpoint(path: "\(taskId)", method: .delete)
        }
    }
}
