//
//  UIView+Buildersw.swift
//  MPC
//
//  Created by Krishna Venkatramani on 24/06/2023.
//

import Foundation
import UIKit

public typealias YAnchor = NSLayoutYAxisAnchor
public typealias XAnchor = NSLayoutXAxisAnchor

public extension UIView {
    
    @discardableResult
    func background(color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func clippedCornerRadius(radius: CGFloat) -> UIView {
        self.clippedCornerRadius = radius
        return self
    }
    
    @discardableResult
    func pinTopAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,YAnchor> = \.topAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.topAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinBottomAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,YAnchor> = \.bottomAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.bottomAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinLeadingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,XAnchor> = \.leadingAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.leadingAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinTrailingAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,XAnchor> = \.trailingAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.trailingAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinCenterXAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,XAnchor> = \.centerXAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerXAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func pinCenterYAnchorTo(_ view: UIView? = nil, anchor: KeyPath<UIView,YAnchor> = \.centerYAnchor, constant: CGFloat) -> UIView {
        guard let viewToPinTo = view ?? superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerYAnchor.constraint(equalTo: viewToPinTo[keyPath: anchor], constant: -constant)
        removeSimilarConstraints([constraint])
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func setWidthOfView(width: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let _ = self.setWidth(width: width, priority: priority)
        return self
    }
    
    @discardableResult
    func setHeightOfView(height: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let _ = self.setHeight(height: height, priority: priority)
        return self
    }
    
    
    var leadingConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == leadingAnchor }.first ?? .init()
    }
    
    var topConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == topAnchor }.first ?? .init()
    }
    
    var trailingConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == trailingAnchor }.first ?? .init()
    }
    
    var bottomConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == bottomAnchor }.first ?? .init()
    }
    
    var heightConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == heightAnchor }.first ?? .init()
    }
    
    var widthConstraint: NSLayoutConstraint {
        constraints.filter { $0.firstAnchor == widthAnchor }.first ?? .init()
    }
    
}
