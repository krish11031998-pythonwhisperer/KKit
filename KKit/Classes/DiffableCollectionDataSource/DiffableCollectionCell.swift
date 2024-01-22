//
//  DiffableCollectionSection.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit
import SwiftUI

// MARK: - DynamicCollectionDiffableDataSource

public typealias DiffableCollectionDataSource = UICollectionViewDiffableDataSource<Int, DiffableCollectionCellItem>

public typealias CollectionDiffableSnapshot = NSDiffableDataSourceSnapshot<Int, DiffableCollectionCellItem>

// MARK: - DynamicCollectionCellProvider

public protocol _DiffableCollectionCellProvider: Hashable, AnyObject {
    func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func didSelect(cv: UICollectionView, indexPath: IndexPath)
    var asCellItem: DiffableCollectionCellItem { get }
}

public typealias DiffableCollectionCellProvider = _DiffableCollectionCellProvider & Hashable

// MARK: - DynamicCollectionCellItem

public enum DiffableCollectionCellItem: Hashable {
    case view(any DiffableCollectionCellProvider)
    case item(any DiffableCollectionCellProvider)
    
    public static func == (lhs: DiffableCollectionCellItem, rhs: DiffableCollectionCellItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .view(let provider):
            hasher.combine(provider)
        case .item(let provider):
            hasher.combine(provider)
        }
    }
}


// MARK: - DiffableCollectionItem

public class DiffableCollectionCell<Cell: DiffableConfigurableCollectionCell>: DiffableCollectionCellProvider {
    
    var model: Cell.Model
    
    public init(_ model: Cell.Model) {
        self.model = model
    }
    
    public var cellRegisteration: UICollectionView.CellRegistration = {
        UICollectionView.CellRegistration<Cell, Cell.Model> { cell, indexPath, item in
            cell.configure(with: item)
        }
    }()
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return cv.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: model)
    }
    
    public func didSelect(cv: UICollectionView, indexPath: IndexPath) {
        guard let action = (model as? ActionProvider)?.action else { return }
        action()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model.hashValue)
    }
    
    public static func == (lhs: DiffableCollectionCell<Cell>, rhs: DiffableCollectionCell<Cell>) -> Bool {
        lhs.model == rhs.model
    }
    
    public var asCellItem: DiffableCollectionCellItem { .view(self) }
}

// MARK: - DiffableCollectionItem

public class DiffableCollectionItem<View: ConfigurableView>: DiffableCollectionCellProvider {
    var model: View.Model
    
    public init(_ model: View.Model) {
        self.model = model
    }
    
    public var cellRegisteration: UICollectionView.CellRegistration = {
        return UICollectionView.CellRegistration<UICollectionViewCell, View.Model> { cell, indexPath, item in
            cell.contentConfiguration = View.createContent(with: item)
        }
    }()
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return cv.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: model)
    }
    
    public func didSelect(cv: UICollectionView, indexPath: IndexPath) {
        guard let action = (model as? ActionProvider)?.action else { return }
        action()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model.hashValue)
    }
    
    public static func == (lhs: DiffableCollectionItem<View>, rhs: DiffableCollectionItem<View>) -> Bool {
        lhs.model == rhs.model
    }
    
    public var asCellItem: DiffableCollectionCellItem { .item(self) }
}
