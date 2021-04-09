//
//  MainViewModel.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol MainViewModelInput {
    func triggerLoadTasks()
    var tapNewTaskBtn: PublishRelay<Void> { get }
    var tapBackBtn: PublishRelay<Void> { get }
    var deleteTask: PublishRelay<TaskCellViewModeling> { get }
    var createTask: PublishRelay<String> { get }
    var query: PublishRelay<String> { get }
}

protocol MainViewModelOutput {
    var tasks: Driver<[TaskCellViewModeling]> { get }
    var onCreateNewTaskTapped: Driver<Void> { get }
    var onBackBtnTapped: Driver<Void> { get }
    var isLoading: Observable<Bool> { get }
    var alertError: Driver<Swift.Error> { get }
}

protocol MainViewModeling {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}

extension Main {
    class ViewModel: MainViewModeling, MainViewModelInput, MainViewModelOutput {
        
        var inputs: MainViewModelInput { return self }
        var outputs: MainViewModelOutput { return self }
        
        private var unFilteredItems = [TaskCellViewModeling]()
        
        let query = PublishRelay<String>()
        
        private var _tasks = PublishRelay<[TaskCellViewModeling]>()
        lazy var tasks = self._tasks.asDriver(onErrorDriveWith: .never()).startWith([])
            
        private var _isLoading = BehaviorRelay<Bool>(value: true)
        lazy var isLoading = self._isLoading.asObservable()
        
        private var _alertError = PublishRelay<Swift.Error>()
        lazy var alertError = self._alertError.asDriver(onErrorDriveWith: .never())
        
        var tapNewTaskBtn = PublishRelay<Void>()
        lazy var onCreateNewTaskTapped = self.tapNewTaskBtn.asDriver(onErrorDriveWith: .never())
        
        var tapBackBtn = PublishRelay<Void>()
        lazy var onBackBtnTapped = self.tapBackBtn.asDriver(onErrorDriveWith: .never())
        
        var deleteTask = PublishRelay<TaskCellViewModeling>()
        
        var createTask = PublishRelay<String>()
        
        var repo: MainRepository!
        
        var disposeBag = DisposeBag()
        
        init(repo: MainRepository = Repo()) {
            self.repo = repo
            setupObservables()
            setupSearcher()
        }
        
        // MARK: Initial load
        func triggerLoadTasks() {
            _isLoading.accept(true)
            repo.getTasks()
                .compactMap({ [weak self] tasks in
                    guard let self = self else { return nil }
                    return tasks.map({ TaskCell.ViewModel(task: $0, repo: self.repo) })
                })
                .do(onNext: { [weak self] tasks in
                    self?.unFilteredItems = tasks
                    self?._isLoading.accept(false)
                }, onError: { [weak self] error in
                    self?._alertError.accept(error)
                    self?._isLoading.accept(false)
                })
                .bind(to: _tasks)
                .disposed(by: disposeBag)
        }
        
        // MARK: Observer search action
        func setupSearcher() {
            query.map({ [unowned self] query -> [TaskCellViewModeling] in
                return query.isEmpty ? self.unFilteredItems :
                    self.unFilteredItems.filter {
                        $0.outputs.title.lowercased().contains(query.lowercased())
                    }
            })
            .flatMapLatest({ Observable<[TaskCellViewModeling]>.just($0) })
            .bind(to: _tasks)
            .disposed(by: disposeBag)
        }
        
        // MARK: Observer delete and create actions
        func setupObservables() {
            
            deleteTask
                .map({ $0.outputs.taskId })
                .flatMapLatest({ [unowned self] taskId in
                    self.repo.delete(taskId: taskId).map({ taskId })
                })
                .do(onError: { [weak self] error in
                    self?._alertError.accept(error)
                })
                .compactMap({ [weak self] taskId in
                    guard let self = self else { return nil }
                    return self.unFilteredItems.filter({ $0.outputs.taskId != taskId })
                })
                .bind(to: _tasks)
                .disposed(by: disposeBag)
            
            createTask
                .filter({ !$0.isEmpty })
                .flatMapLatest({ [unowned self] task in
                    self.repo.create(task: task)
                })
                .do(onError: { [weak self] error in
                    self?._alertError.accept(error)
                })
                .subscribe(onNext:{ [weak self] _ in
                    self?.triggerLoadTasks()
                })
                .disposed(by: disposeBag)
        }
   }
}
