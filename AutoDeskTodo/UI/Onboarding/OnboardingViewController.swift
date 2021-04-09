//
//  OnboardingViewController.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

// MARK:- ViewController
extension Onboarding {
    class ViewController: UIViewController {
        
        let viewModel: OnboardingViewModeling
        
        var timer = Timer()
        
        var currentTitleIndex: Int = 0
        
        var titleView = "".label
            .font(AppFonts.large)
            .textAlignment(.center)
            .textColor(ColorPalette.blackish)
        
        var lblSubtitle = "Tap on Sign in to start".label
            .font(AppFonts.writer)
            .textAlignment(.center)
            .textColor(ColorPalette.blackish)
        
        lazy var btnLogin = "Sign in".button
            .textColor(.white)
            .font(AppFonts.writer)
            .backgroundColor(.systemBlue)
            .corner(radius: 27)
            .tap(target: self, action: #selector(loginTapped))
        
        init(viewModel: OnboardingViewModeling = ViewModel()) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
            setupViews()
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(onTransition), userInfo: nil, repeats: true)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            timer.fire()
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidAppear(animated)
            timer.invalidate()
        }
        
//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        }
//        
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
        
        @objc func onTransition() {
            UIView.transition(with: titleView, duration: 1.5, options: .transitionCrossDissolve, animations: {
                self.titleView.text =  self.viewModel.outputs.nextTitle()
            }, completion: nil)
        }
        
        @objc func loginTapped() {
            viewModel.inputs.btnNextTapped.accept(())
        }
    }
}


// MARK: - UI Setup
extension Onboarding.ViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.add(subviews: titleView, lblSubtitle, btnLogin)
        
        titleView.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.leading.trailing.equalToSuperview().inset(25)
            make.centerY.equalToSuperview().dividedBy(1.5)
        }
        
        lblSubtitle.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(16)
        }
        
        btnLogin.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalTo(311)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(95)
        }
    }
}
