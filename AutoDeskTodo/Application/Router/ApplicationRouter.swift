//
//  Router.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit
import Foundation

extension Application {
    
    class Router: Routable {

        private weak var rootController: UINavigationController?
        
        init(rootController: UINavigationController = UINavigationController()) {
            self.rootController = rootController
        }
        
        var showNavigationBar: Bool = false {
            didSet {
                rootController?.isNavigationBarHidden = !showNavigationBar
            }
        }
        
        func toPresent() -> UIViewController? {
            return rootController
        }
        
        func setRootModule(_ module: Presentable?, animated: Bool = true) {
            guard let controller = module?.toPresent() else { return }
            if animated {
                animate(with: .fromLeft)
            }
            rootController?.setViewControllers([controller], animated: false)
        }
        
        func present(_ module: Presentable?, animated: Bool) {
            guard let controller = module?.toPresent() else { return }
            if let presentedVC = rootController?.presentedViewController {
                presentedVC.dismiss(animated: true) { [weak self] in
                    self?.rootController?.present(controller, animated: animated, completion: nil)
                }
            } else {
                rootController?.present(controller, animated: animated, completion: nil)
            }
        }
        
        func push(_ module: Presentable?, animated: Bool) {
            guard
                let controller = module?.toPresent(),
                (controller is UINavigationController == false)
                else { assertionFailure("Deprecated push UINavigationController."); return }
            
            if animated {
                animate(with: .fromLeft)
            }
            
            rootController?.pushViewController(controller, animated: false)
        }
        
        @discardableResult func popToRootModule(animated: Bool) -> Bool {
            if animated {
                animate(with: .fromRight)
            }
            return rootController?.popToRootViewController(animated: false) != nil
        }
        
        func dismissModule(animated: Bool, completion: (() -> Void)?) {
            rootController?.dismiss(animated: animated, completion: completion)
        }
        
        @discardableResult func popModule(animated: Bool) -> Bool {
            if animated {
                animate(with: .fromRight)
            }
            return rootController?.popViewController(animated: false) != nil
        }
        
        @discardableResult func popTo(module: Presentable, animated: Bool) -> Bool {
            guard let controller = module.toPresent() else { return false }
            if animated {
                animate(with: .fromRight)
            }
            return rootController?.popToViewController(controller, animated: false) != nil
        }
        
        func setRootModule(_ module: Presentable?) {
            setRootModule(module, animated: true)
        }
        
        func present(_ module: Presentable?) {
            present(module, animated: true)
        }
        
        func push(_ module: Presentable?) {
            push(module, animated: true)
        }
        
        func dismissModule(completion: (() -> Void)?) {
            dismissModule(animated: true, completion: completion)
        }
        
        func popToRootModule() -> Bool {
            popToRootModule(animated: true)
        }
        
        func popModule() -> Bool {
            popModule(animated: true)
        }
        
        func popTo(module: Presentable) -> Bool {
            popTo(module: module, animated: true)
        }
        
        func animate(with subType: CATransitionSubtype? = nil) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.subtype = subType
            rootController?.view.layer.add(transition, forKey: kCATransition)
        }
    }
}
