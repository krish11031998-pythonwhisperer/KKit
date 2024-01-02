//
//  ConfigurableElement.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import Foundation


// MARK: - ConfigurableElement

public protocol ConfigurableElement {
    associatedtype Model: Hashable
    static func createContent(with model: Model) -> UIContentConfiguration
    static var viewName: String { get }
    
}
// MARK: - UIViewCOnfiguration

extension UIView: UIContentView {
    public var configuration: UIContentConfiguration {
        get {
            UIViewConfiguration(view: self)
        }
        set(newValue) { }
    }
}

public class UIViewConfiguration: UIContentConfiguration {
    private let view: UIView
    
    
    public init(view: UIView) {
        self.view = view
    }
    
    public func makeContentView() -> UIView & UIContentView {
        return view
    }
    
    public func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
