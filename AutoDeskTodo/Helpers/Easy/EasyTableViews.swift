//
//  EasyTableViews.swift
//
//  Created by Shalom on 17/03/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.

import UIKit

extension UITableView {
    
    @discardableResult
    func register(headers: UITableViewHeaderFooterView.Type...) -> Self {
        self.register(headers: headers )
        return self
    }
    
    @discardableResult
    func register(headers: [UITableViewHeaderFooterView.Type]) -> Self {
        for header in headers {
            self.register(header: header)
        }
        return self
    }
    
    @discardableResult
    func register(header: UITableViewHeaderFooterView.Type) -> Self {
        self.register(header, forHeaderFooterViewReuseIdentifier: header.identifierName)
        return self
    }
    
    @discardableResult
    func register(cells: UITableViewCell.Type...) -> Self {
        self.register(cells: cells)
        return self
    }
    
    @discardableResult
    func register(cells: [UITableViewCell.Type]) -> Self {
        for cell in cells {
            self.register(cell: cell)
        }
        return self
    }
    
    @discardableResult
    func register(cell: UITableViewCell.Type) -> Self {
        self.register(cell, forCellReuseIdentifier: cell.identifierName)
        return self
    }
    
    @discardableResult
    func reuse<T: UITableViewCell>(cell: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: cell.identifierName) as! T
    }
    
    @discardableResult
    func reuse<T: UITableViewHeaderFooterView>(header view: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: view.identifierName) as! T
    }
    
    @discardableResult
    func rowHeight(estimated value: CGFloat, automatic: Bool) -> Self {
        self.estimatedRowHeight = value
        self.rowHeight = automatic ? UITableView.automaticDimension : value
        return self
    }
    
    @discardableResult
    func sectionHeader(height: CGFloat) -> Self {
        self.sectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    func separator(style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    
    @discardableResult
    func separator(inset: UIEdgeInsets) -> Self {
        self.separatorInset = inset
        return self
    }
    
    @discardableResult
    func separator(color: UIColor) -> Self {
        self.separatorColor = color
        return self
    }
    
    @discardableResult
    func isScroll(enabled: Bool) -> Self {
        self.isScrollEnabled = enabled
        return self
    }
    
    @discardableResult
    func contentInset(_ value: UIEdgeInsets) -> Self {
        self.contentInset = value
        return self
    }
    
    @discardableResult
    func show(verticalScrollIndicator value: Bool) -> Self {
        self.showsVerticalScrollIndicator = value
        return self
    }
    
    @discardableResult
    func show(horizontalScrollIndicator value: Bool) -> Self {
        self.showsHorizontalScrollIndicator = value
        return self
    }
    
    func show(scrollIndicators value: Bool) -> Self {
        show(horizontalScrollIndicator: value)
        show(verticalScrollIndicator: value)
        return self
    }
    
    func hideFooterView() -> Self {
        self.tableFooterView = UIView()
        return self
    }
    
    @discardableResult
    func verticalBouncedWhenNeeded() -> Self {
        self.alwaysBounceVertical = false
        return self
    }
}

extension UICollectionView {
    
    func register(cells: UICollectionViewCell.Type...) {
        self.register(cells: cells)
    }
    
    func register(cells: [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(cell: cell)
        }
    }
    
    func register(cell: UICollectionViewCell.Type) {
        self.register(cell, forCellWithReuseIdentifier: cell.identifierName)
    }
    
    func reuse<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: cell.identifierName, for: indexPath) as! T
    }
}

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }

    func scrollToLastRow(inSection section: Int = 0, animated: Bool) {
        let numberOfRows = self.numberOfRows(inSection: section)
        if  numberOfRows > 0 {
            self.scrollToRow(at: IndexPath(row: numberOfRows - 1, section: section), at: .bottom, animated: animated)
        }
    }
}

extension UICollectionViewCell {
    static var identifierName: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var identifierName: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var identifierName: String {
        return String(describing: self)
    }
}

extension Int {
    var indexSet: IndexSet {
        return .init(arrayLiteral: self)
    }
}

extension IndexPath {
    var cacheKey: String {
        return String(describing: self)
    }
}
