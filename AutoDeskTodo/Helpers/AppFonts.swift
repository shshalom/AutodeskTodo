//
//  AppFonts.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit
import SwiftUI

public enum AppFonts: String {
    case regular
    case bold
    
    func ofSize(_ size: CGFloat) -> UIFont {
        switch self {
        case .regular: return .systemFont(ofSize: size)
        case .bold: return .boldSystemFont(ofSize: size)
        }
    }
}

extension AppFonts {
    static var large: UIFont { bold.ofSize(52)}
    static var title: UIFont { bold.ofSize(18) }
    static var category: UIFont { regular.ofSize(17) }
    static var writer: UIFont { regular.ofSize(16) }
    static var info: UIFont { regular.ofSize(12) }
    static var infoBold: UIFont { bold.ofSize(12) }
}
