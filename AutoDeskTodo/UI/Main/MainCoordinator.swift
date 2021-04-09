//
//  MainCoordinator.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit
import RxSwift

protocol MainCoordinatorOutput: class {
    typealias FinishClosure = () -> Void
    
    var finishFlow: FinishClosure! { get set }
}

extension Main {
    
    class Coordinator: Coordinators.Base, MainCoordinatorOutput {
        
        var finishFlow: FinishClosure!
        var viewModel: MainViewModeling!
        var disposeBag: DisposeBag = DisposeBag()
        
        init(viewModel: MainViewModeling = Main.ViewModel(), router: Routable) {
            super.init()
            self.viewModel = viewModel
            self.router = router
            
            setupObservables()
        }

        override func start() {
            showMainController()
        }
        
        func showMainController() {
            let vc = ViewController(viewModel: viewModel)
            router?.showNavigationBar = true
            router?.push(vc, animated: true)
        }
        
        func presentNewTaskDialog() {
            let alertController = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Task"
            }
            
            let saveAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                let textField = alertController.textFields![0]
                self?.viewModel.inputs.createTask.accept(textField.text ?? "")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in})
            
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            router?.present(alertController)
        }
        
        func present(error: Swift.Error) {
            let alertController = UIAlertController(title: "Opps, something went wrong", message: error.localizedDescription, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: {_ in})
            
            alertController.addAction(cancelAction)
            
            router?.present(alertController)
        }
    }
}

// MARK: - Setup Observables

extension Main.Coordinator {
    func setupObservables() {
        
        viewModel.outputs.onCreateNewTaskTapped
            .drive(onNext: { [weak self] in
                self?.presentNewTaskDialog()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.onBackBtnTapped
            .drive(onNext: { [weak self] in
                self?.finishFlow()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.alertError
            .drive(onNext: { [weak self] error in
                self?.present(error: error)
            })
            .disposed(by: disposeBag)
    }
}
