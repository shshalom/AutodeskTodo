//
//  Presentable.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

// MARK: - Default Implementation
extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}
