//
//  EasyViews.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import Foundation
import UIKit
import SnapKit

extension UIView {
    @discardableResult func add(to: Any, withConstraints closure: ((ConstraintMaker) -> Void)? = nil) -> Self {
        if to is UIView {
            (to as! UIView).addSubview(self)
        } else if to is UIViewController {
             (to as! UIViewController).view.addSubview(self)
        }
        
        if let closure = closure {
            self.snp.makeConstraints(closure)
        }
        
        return self
    }
    
    @discardableResult
    func add(subviews views: UIView...) -> Self {
        views.forEach({ addSubview($0) })
        
        return self
    }
    
    @discardableResult @objc func alpha(_ value: CGFloat) -> Self {
        self.alpha = value
        return self
    }
    
    @discardableResult func maskToBounds(_ value: Bool) -> Self {
        self.layer.masksToBounds = value
        return self
    }
    
    @discardableResult func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult func wrapContent(axis: NSLayoutConstraint.Axis? = nil, priority: UILayoutPriority = UILayoutPriority.required ) -> Self {
        let both = axis == nil
        if axis == .horizontal || both {
            self.setContentCompressionResistancePriority(priority, for: .horizontal)
        }
        if axis == .vertical || both {
            self.setContentCompressionResistancePriority(priority, for: .vertical)
        }
        return self
    }

    @discardableResult func hugContent(axis: NSLayoutConstraint.Axis? = nil, priority: UILayoutPriority = .required) -> Self {
        let both = axis == nil
        if axis == .horizontal || both {
            self.setContentHuggingPriority(priority, for: .horizontal)
        }
        if axis == .vertical || both {
            self.setContentHuggingPriority(priority, for: .vertical)
        }
        return self
    }
    
    @discardableResult func corner(radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = radius != 0
        
        return self
    }
    
    @discardableResult func border(width: CGFloat, color: UIColor, dashed: Bool = false) -> Self {
        if dashed {
            let borderView = CAShapeLayer()
            borderView.strokeColor = color.cgColor
            borderView.lineDashPattern = [1, 1]
            borderView.frame = self.bounds
            borderView.fillColor = nil
            borderView.cornerRadius = self.layer.cornerRadius
            borderView.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(borderView)
        } else {
            self.layer.borderWidth = width
            self.layer.borderColor = color.cgColor
        }
        
        return self
    }
    
    @discardableResult func tapGesture(target: Any?, action: Selector) -> Self {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(gesture)
        
        return self
    }
    
    @discardableResult func corners(_ corners: UIRectCorner, radius: CGFloat) -> Self {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
        return self
    }
    
    @discardableResult func mask(with layer: CALayer) -> Self {
        self.layer.mask = layer
        
        return self
    }
}

@objc extension UIView {
    @discardableResult func isHidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }
}

@objc extension UILabel {
    @discardableResult func font(_ font: UIFont) -> UILabel {
        self.font = font
        return self
    }
    
    @discardableResult func minimumFontSize(_ size: CGFloat) -> UILabel {
        self.minimumScaleFactor = size / self.font.pointSize
        return self
    }
    
    @discardableResult func adjustsFontSizeToFitWidth(_ adjust: Bool) -> UILabel {
        self.adjustsFontSizeToFitWidth = adjust
        return self
    }
    
    @discardableResult func textColor(_ color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    
    @discardableResult func numberOfLines(_ number: Int) -> UILabel {
        self.numberOfLines = number
        return self
    }
    
    @discardableResult func textAlignment(_ textAlignment: NSTextAlignment) -> UILabel {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult func lineSpacing(_ spacing: CGFloat = 0, lineHeightMultiple: CGFloat = 0.0) -> UILabel {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = spacing
        paragraph.lineHeightMultiple = lineHeightMultiple
        paragraph.alignment = textAlignment
        
        let text: NSMutableAttributedString
        if let attributedText = attributedText {
            text = NSMutableAttributedString(attributedString: attributedText)
        } else {
            text = NSMutableAttributedString(string: self.text ?? "")
        }

        text.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: text.length))
        self.attributedText = text

        return self
    }

    @discardableResult func letterSpacing(_ spacing: CGFloat) -> UILabel {
        let text: NSMutableAttributedString
        if let attributedText = attributedText {
            text = NSMutableAttributedString(attributedString: attributedText)
        } else {
            text = NSMutableAttributedString(string: self.text ?? "")
        }
        
        //swiftlint:disable:next compiler_protocol_init
        let value = NSNumber(floatLiteral: Double(spacing))
        
        text.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: text.length))
        self.attributedText = text.copy() as? NSAttributedString
        
        return self
    }
}

extension UITextField {
    @discardableResult func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult func adjustsFontSizeToFitWidth(_ adjust: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjust
        return self
    }
    
    @discardableResult func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult func leftPadding(_ value: CGFloat) -> Self {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        return self
    }
}

extension UIControl {
    @discardableResult func tap(target: Any?, action: Selector) -> Self {
        addTarget(target, action: action, for: .touchUpInside)
        return self
    }
}

extension UIButton {
    @discardableResult func centerVertically(padding: CGFloat = 0.0) -> Self {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return self
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
        
        return self
    }
    
    @discardableResult func font(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult func titleEdge(inset: UIEdgeInsets) -> Self {
        self.titleEdgeInsets = inset
        return self
    }
 
    @discardableResult func withImage(_ image: UIImage) -> Self {
        self.setImage(image, for: .normal)
        return self
    }
    
    @discardableResult func textColor(_ color: UIColor) -> Self {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)
        return self
    }
    
    @discardableResult func contentEdgeInsets(_ inset: UIEdgeInsets) -> Self {
        self.contentEdgeInsets = inset
        return self
    }

    @discardableResult func withPadding(_ padding: CGFloat) -> UIButton {
        self.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return self
    }
    
    @discardableResult func tintColor(_ color: UIColor) -> UIButton {
        self.tintColor = color
        return self
    }
    
    @discardableResult func horizontalAlignment(_ align: UIControl.ContentHorizontalAlignment) -> UIButton {
        self.contentHorizontalAlignment = align
        return self
    }
    
    @discardableResult func verticalAlignment(_ align: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = align
        return self
    }
}

extension UIImageView {
    @discardableResult func contentMode(_ contentMode: UIView.ContentMode) -> UIImageView {
        self.contentMode = contentMode
        return self
    }
    
    @discardableResult func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
}

extension String {
    var label: UILabel {
        let label = UILabel()
        label.text = self
        return label
    }
    
    var textField: UITextField {
        let tf = UITextField()
        tf.text = self
        return tf
    }
    
    var button: UIButton {
        return button(withType: .system)
    }
    
    var barButton: UIBarButtonItem {
        return UIBarButtonItem(title: self, style: .plain, target: nil, action: nil)
    }
    
    func tabBarButton(tag: Int = 0) -> UITabBarItem {
        return UITabBarItem(title: self, image: nil, tag: tag)
    }

    func button(withType type: UIButton.ButtonType) -> UIButton {
        let button = UIButton(type: type)
        button.setTitle(self, for: .normal)
        return button
    }
    
    var image: UIImage? {
        if self.isEmpty {
            return UIImage()
        }
        return UIImage(named: self)
    }
    
    var url: URL? {
        return URL(string: self)
    }
}

func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
    let string = NSMutableAttributedString(attributedString: lhs)
    string.append(rhs)
    return string
}

extension NSAttributedString {
    var label: UILabel {
        let label = UILabel()
        label.attributedText = self
        return label
    }
    
    var button: UIButton {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(self, for: .normal)
        return button
    }
    
    var barButton: UIBarButtonItem {
        let barButton = UIBarButtonItem()
        button.setAttributedTitle(self, for: .normal)
        button.setAttributedTitle(self, for: .selected)
        
        return barButton
    }
}

extension UIImage {
    var view: UIImageView {
        return UIImageView(image: self)
    }
    
    var button: UIButton {
        return button(with: .system)
    }
    
    var barButton: UIBarButtonItem {
        return UIBarButtonItem(image: self, style: .plain, target: nil, action: nil)
    }
    
    func tabBarButton(tag: Int = 0) -> UITabBarItem {
        return UITabBarItem(title: nil, image: self, tag: tag)
    }

    func button(with type: UIButton.ButtonType) -> UIButton {
        let button = UIButton(type: type)
        button.setImage(self, for: .normal)
        return button
    }
    
    var template: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

extension UIBarButtonItem {
    
    @discardableResult func tap(target: Any?, action: Selector) -> Self {
        self.action = action
        self.target = target as AnyObject
        return self
    }
    
    @discardableResult func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult func font(_ font: UIFont, for state: UIControl.State? = nil) -> Self {
        var atts = self.titleTextAttributes(for: state ?? .normal) ?? [:]
            atts.updateValue(font, forKey: NSAttributedString.Key.font)
        
        self.setTitleTextAttributes(atts, for: state ?? .normal)
        if state == nil {
            self.setTitleTextAttributes(atts, for: .highlighted)
        }
        return self
    }
    
    @discardableResult func textColor(_ color: UIColor, for state: UIControl.State? = nil) -> Self {
        var atts = self.titleTextAttributes(for: state ?? .normal) ?? [:]
        atts.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
        
        self.setTitleTextAttributes(atts, for: state ?? .normal)
        if state == nil {
            self.setTitleTextAttributes(atts, for: .highlighted)
        }
        return self
    }
}

extension Array where Element: UITabBarItem {
    
    var tabBar: UITabBar {
        let tb = UITabBar()
        tb.items = self
        tb.itemPositioning = .automatic
        
        return tb
    }
}

extension UIColor {
    func image(ofSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension CGSize {
    var asRect: CGRect {
        return CGRect(origin: .zero, size: self)
    }
}

extension Int {
    var priority: UILayoutPriority {
        return UILayoutPriority(rawValue: Float(self))
    }
}

extension UIViewController {
    func insideNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
