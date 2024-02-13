//
//  ConfigurableUIView.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import UIKit


// MARK: - ConfigurableUIViewProvider

public protocol ConfigurableUIViewProvider: UIView {
    var inset: UIEdgeInsets { get }
    var background: UIColor { get }
    func prepareViewForReuse()
}

public extension ConfigurableUIViewProvider {
    var inset: UIEdgeInsets { .zero }
    var background: UIColor { .clear }
    func prepareViewForReuse() {}
}


// MARK: - ConfigurableUIView

public typealias ConfigurableUIView = ConfigurableElement & UIView

public extension ConfigurableElement where Self: UIView {
    static var viewName: String { Self.name }
    
    static func createContent(with model: Model) -> UIContentConfiguration {
        let view = Self.init()
        view.configure(with: model)
        return UIViewConfiguration(view: view)
    }
    
    static var cellName: String {
        "\(viewName)_CollectionViewCell"
    }
}
