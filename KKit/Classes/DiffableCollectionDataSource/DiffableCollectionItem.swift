//
//  DiffableCollectionSection.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit


// MARK: - DynamicCollectionDiffableDataSource

public typealias DiffableCollectionDiffableDataSource = UICollectionViewDiffableDataSource<Int, DiffableCollectionCellItem>

// MARK: - DynamicCollectionCellProvider

public protocol DiffableCollectionCellProvider: Hashable, AnyObject {
    func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func didSelect(cv: UICollectionView, indexPath: IndexPath)
}


// MARK: - DynamicCollectionCellItem

public enum DiffableCollectionCellItem: Hashable {
    case item(any DiffableCollectionCellProvider)
    
    public static func == (lhs: DiffableCollectionCellItem, rhs: DiffableCollectionCellItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        guard case .item(let type) = self else {
            return
        }
        hasher.combine(type.hashValue)
    }
}


// MARK: - DynamicCollectionItem

public class DiffableCollectionItem<Cell: DiffableConfigurableCollectionCell>: DiffableCollectionCellProvider, Hashable {
    
    var model: Cell.Model
    
    public init(_ model: Cell.Model) {
        self.model = model
    }
    
    public func cell(cv: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: Cell = cv.dequeueCell(indexPath: indexPath) else {
            return .init()
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
    
    public static func == (lhs: DiffableCollectionItem<Cell>, rhs: DiffableCollectionItem<Cell>) -> Bool {
        lhs.model == rhs.model
    }
}
