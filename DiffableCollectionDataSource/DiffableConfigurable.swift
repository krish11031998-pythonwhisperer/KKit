//
//  DiffableConfigurable.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import Foundation

// MARK: - DynamicConfigurable

public protocol DiffableConfigurable {
    associatedtype Model: Hashable
    func configure(with model: Model)
    static var cellName: String { get }
}

public extension DiffableConfigurable {
    static var cellName: String { UUID().uuidString }
}

public typealias DiffableConfigurableCollectionCell = DiffableConfigurable & UICollectionViewCell

