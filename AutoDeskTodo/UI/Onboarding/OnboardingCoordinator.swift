//
//  OnboardingCoordinator.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit
import RxSwift

protocol OnboardingCoordinatorOutput: class {
    typealias FinishClosure = () -> Void
    
    var finishFlow: FinishClosure! { get set }
}

extension Onboarding {
    
    class Coordinator: Coordinators.Base, OnboardingCoordinatorOutput {
        
        var finishFlow: FinishClosure!
        var viewModel: OnboardingViewModeling!
        var disposeBag: DisposeBag = DisposeBag()
        
        init(viewModel: OnboardingViewModeling = Onboarding.ViewModel(), router: Routable) {
            super.init()
            self.viewModel = viewModel
            self.router = router
        }

        override func start() {
            runOnboarding()
        }
        
        func runOnboarding() {
            let vc = ViewController(viewModel: viewModel)
            router?.showNavigationBar = false
            router?.setRootModule(vc, animated: false)
            
            viewModel.outputs.showNextScreen
                .subscribe(onNext: { [weak self] in
                    self?.finishFlow()
                })
                .disposed(by: disposeBag)
        }
    }
}
