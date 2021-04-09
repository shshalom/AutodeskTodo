//
//  TaskCellViewModel.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

protocol TaskCellViewModelInput {
    var toggleStatus: PublishRelay<Void> { get }
}

protocol TaskCellViewModelOutput {
    var title: String { get }
    var status: Driver<Bool> { get }
    var taskId: String { get }
}

protocol TaskCellViewModeling {
    var inputs: TaskCellViewModelInput { get }
    var outputs: TaskCellViewModelOutput { get }
}

extension Main.TaskCell {
    
    class ViewModel: TaskCellViewModeling, TaskCellViewModelInput, TaskCellViewModelOutput {
        var inputs: TaskCellViewModelInput { return self }
        var outputs: TaskCellViewModelOutput { return self }
        
        private var disposeBag = DisposeBag()
        
        private var task: Task
        
        private var _status = BehaviorRelay<Bool>(value: false)
        
        lazy var status = self._status.asDriver(onErrorJustReturn: false)
        
        var taskId: String { task.id }
        
        var title: String { task.title }
        
        var toggleStatus = PublishRelay<Void>()
        
        var repo: MainRepository
        
        init(task: Task, repo: MainRepository) {
            self.task = task
            self.repo = repo
            
            setupObservabels()
        }
        
        private func setupObservabels() {
            _status.accept(task.completed)
            
            toggleStatus.map({ [unowned self] in
                self.task.completed = !self.task.completed
            })
            .flatMapLatest({ [unowned self] in
                repo.update(task: task).asObservable()
            })
            .filter({ [weak self] task in
                guard let self = self else { return false }
                return task.completed == self.task.completed
            })
            .do(onNext: { [weak self] task in
                self?.task = task
            })
            .map({ $0.completed })
            .bind(to: _status)
            .disposed(by: disposeBag)
        }
   }
}
