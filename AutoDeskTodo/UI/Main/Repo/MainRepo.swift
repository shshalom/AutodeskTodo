//
//  MainRepo.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import RxSwift

// MARK: - Main Repository

protocol MainRepository {
    func getTasks() -> Observable<[Task]>
    func update(task: Task) -> Single<Task>
    func create(task title: String) -> Single<Task>
    func delete(taskId: String) -> Single<Void>
}

extension Main {
    
    typealias DataSource = MainRepository
    
    class Repo: MainRepository {
        private let remoteDataSource: DataSource
        private let localDataSource: DataSource
        
        init(remote: DataSource = RemoteDataSource(), local: DataSource = LocalDataSource()) {
            self.remoteDataSource = remote
            self.localDataSource = local
        }
        
        func getTasks() -> Observable<[Task]> {
            let remote = remoteDataSource.getTasks()
            let local = localDataSource.getTasks()
            
            return Observable.merge([remote, local])
        }
        
        func update(task: Task) -> Single<Task> {
            remoteDataSource.update(task: task)
        }
        
        func create(task title: String) -> Single<Task> {
            remoteDataSource.create(task: title)
        }
        
        func delete(taskId: String) -> Single<Void> {
            remoteDataSource.delete(taskId: taskId)
        }
    }
}
