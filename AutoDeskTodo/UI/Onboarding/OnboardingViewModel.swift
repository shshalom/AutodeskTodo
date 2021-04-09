//
//  OnboardingViewModel.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

protocol OnboardingViewModelInput {
    var btnNextTapped: PublishRelay<Void> { get }
}

protocol OnboardingViewModelOutput {
    func nextTitle() -> String
    var showNextScreen: Observable<Void> { get }
}

protocol OnboardingViewModeling {
    var inputs: OnboardingViewModelInput { get }
    var outputs: OnboardingViewModelOutput { get }
}

extension Onboarding {
    class ViewModel: OnboardingViewModeling, OnboardingViewModelInput, OnboardingViewModelOutput {
        var inputs: OnboardingViewModelInput { self }
        var outputs: OnboardingViewModelOutput { self }
        
        var currentTitleIndex: Int = 0
        
        var btnNextTapped = PublishRelay<Void>()
        
        lazy var showNextScreen = self.btnNextTapped.asObservable()
        
        private var titles = ["Control", "Manage", "Enhanch", "Work", "Fight", "Smash"]
        
        func nextTitle() -> String {
            if (currentTitleIndex < titles.count - 1) {
                currentTitleIndex += 1
            } else {
                currentTitleIndex = 0
            }
            
            return titles[currentTitleIndex]
        }
   }
}
