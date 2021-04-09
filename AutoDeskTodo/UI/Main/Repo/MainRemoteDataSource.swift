//
//  MainRemoteDataSource.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation
import RxSwift

// MARK: - Remote Data Source

extension Main {
    class RemoteDataSource: DataSource {
        
        func getTasks() -> Observable<[Task]> {
            return Observable.create { subscriber -> Disposable in
                
                let router = TasksRouter.tasks
                let request = router.request { (result: Result<[Task], Error>) in
                    switch result {
                    case let .success(tasks):
                        subscriber.onNext(tasks)
                        subscriber.onCompleted()
                    case let .failure(error):
                        subscriber.onError(error)
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        }
        
        func update(task: Task) -> Single<Task> {
            return Single.create { single -> Disposable in
                
                let router = TasksRouter.update(task: task)
                let request = router.request { (result: Result<Task, Error>) in
                    switch result {
                    case let .success(task):
                        single(.success(task))
                    case let .failure(error):
                        single(.error(error))
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        }
        
        func create(task title: String) -> Single<Task> {
            return Single.create { single -> Disposable in
                
                let router = TasksRouter.new(taskTitle: title)
                let request = router.request { (result: Result<Task, Error>) in
                    switch result {
                    case let .success(task):
                        single(.success(task))
                    case let .failure(error):
                        single(.error(error))
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        }
        
        func delete(taskId: String) -> Single<Void> {
            return Single.create { single -> Disposable in
                
                let router = TasksRouter.delete(taskId: taskId)
                let request = router.request { (result: Result<Void, Error>) in
                    switch result {
                    case .success:
                        single(.success(()))
                    case let .failure(error):
                        single(.error(error))
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        }
    }
}
