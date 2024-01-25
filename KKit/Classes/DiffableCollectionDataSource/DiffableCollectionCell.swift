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

public protocol DiffableCollectionCellProviderType: Hashable, AnyObject {
    func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func didSelect(cv: UICollectionView, indexPath: IndexPath)
    var asCellItem: DiffableCollectionCellItem { get }
    func register(cv: UICollectionView, registration: inout [String])
}

public typealias DiffableCollectionCellProvider = any DiffableCollectionCellProviderType

// MARK: - DynamicCollectionCellItem

public enum DiffableCollectionCellItem: Hashable {
    case view(DiffableCollectionCellProvider)
    case item(DiffableCollectionCellProvider)
    
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


// MARK: - DiffableCollectionCell

public class DiffableCollectionCell<Cell: DiffableConfigurableCollectionCell>: DiffableCollectionCellProviderType {
    
    var model: Cell.Model
    
    public init(_ model: Cell.Model) {
        self.model = model
    }
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: Cell = cv.dequeueCell(indexPath: indexPath) else {
            let cell = UICollectionViewCell()
            let cellView = Cell()
            cellView.configure(with: model)
            cell.contentView.addSubview(cellView)
            cellView.fillSuperview()
            return cell
        }
        cell.configure(with: model)
        return cell
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
    
    public func register(cv: UICollectionView, registration: inout [String]) {
        guard (registration.first(where: { $0 == Cell.cellName }) == nil) else { return }
        cv.register(Cell.self, forCellWithReuseIdentifier: Cell.cellName)
        registration.append(Cell.cellName)
    }
}


// MARK: - DiffableCollectionItem

public class DiffableCollectionItem<View: ConfigurableView>: DiffableCollectionCellProviderType {
    var model: View.Model
    
    public init(_ model: View.Model) {
        self.model = model
    }
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        cell.contentConfiguration = View.createContent(with: model)
        return cell
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
    
    private var cellName: String { "\(View.viewName)Cell" }
    
    public func register(cv: UICollectionView, registration: inout [String]) {
        guard (registration.first(where: { $0 == cellName }) == nil) else { return }
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellName)
        registration.append(cellName)
    }
}
