//
//  MainLocalDataSource.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation
import RxSwift

// MARK: - Local Data Source
// Manage local datasource

extension Main {
    class LocalDataSource: DataSource {
        func getTasks() -> Observable<[Task]> {
            .never()
        }
        
        func update(task: Task) -> Single<Task> {
            .never()
        }
        
        func create(task title: String) -> Single<Task> {
            .never()
        }
        
        func delete(taskId: String) -> Single<Void> {
            .never()
        }
    }
}
