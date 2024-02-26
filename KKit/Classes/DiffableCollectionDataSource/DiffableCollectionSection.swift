//
//  DiffableCollectionSection.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit


// MARK: - DynamicCollectionSection

public class DiffableCollectionSection: Hashable, Identifiable {
    
    public var id: Int
    var cells: [DiffableCollectionCellProvider]
    var sectionLayout: NSCollectionLayoutSection
    var header: (any CollectionSupplementaryViewProvider)?
    var footer: (any CollectionSupplementaryViewProvider)?
    
    public init(_ id: Int, cells: [DiffableCollectionCellProvider], header: (any CollectionSupplementaryViewProvider)? = nil, footer: (any CollectionSupplementaryViewProvider)? = nil, sectionLayout: NSCollectionLayoutSection) {
        self.cells = cells
        self.header = header
        self.footer = footer
        self.id = id
        self.sectionLayout = sectionLayout
    }
    
    var asItem: [DiffableCollectionCellItem] { cells.map(\.asCellItem) }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DiffableCollectionSection, rhs: DiffableCollectionSection) -> Bool {
        lhs.id == rhs.id
    }
    
    public func registerCells(collectionView: UICollectionView, cellRegistrationsMap: inout Set<String>) {
        cells.forEach { cell in
            cell.register(cv: collectionView, registration: &cellRegistrationsMap)
        }
    }
}


public extension DiffableCollectionSection {
    
    func replaceCellWith(newCell: DiffableCollectionCellProvider) {
        guard let idx = self.cells.firstIndex(where: { $0.asCellItem == newCell.asCellItem }) else {
            self.cells.append(newCell)
            return
        }
        
        self.cells[idx] = newCell
    }
    
}
