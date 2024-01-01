//
//  DiffableCollectionSection.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit


// MARK: - DynamicCollectionSection

public class DiffableCollectionSection {
    var id: String
    let cells: [any DiffableCollectionCellProvider]
    let sectionLayout: NSCollectionLayoutSection
    
    public init(cells: [any DiffableCollectionCellProvider], sectionLayout: NSCollectionLayoutSection) {
        self.cells = cells
        self.id = UUID().uuidString
        self.sectionLayout = sectionLayout
    }
    
    var asItem: [DiffableCollectionCellItem] { cells.map({ .item($0) }) }
}


// MARK: - UICollectionView

public extension UICollectionView {
    
    static var dynamicDataSourceKey: UInt8 = 1
    
    var dynamicDataSource: DiffableCollectionDiffableDataSource? {
        get { objc_getAssociatedObject(DiffableCollectionDiffableDataSource.self, &Self.dynamicDataSourceKey) as? DiffableCollectionDiffableDataSource }
        set { objc_setAssociatedObject(DiffableCollectionDiffableDataSource.self, &Self.dynamicDataSourceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    func reloadWithDynamicSection(sections: [DiffableCollectionSection]) {
        
        guard self.dynamicDataSource == nil else {
            self.apply(diffableSections: sections)
            return
        }
        
        let dataSource = DiffableCollectionDiffableDataSource(collectionView: self) { collectionView, indexPath, item in
            guard case .item(let cellItem) = item else {
                return UICollectionViewCell()
            }
            
            return cellItem.cell(cv: collectionView, indexPath: indexPath)
        }
        
        self.dynamicDataSource = dataSource
        setupCollectionViewLayout(dynamicSections: sections)
        self.apply(diffableSections: sections)
    }
    
    func apply(diffableSections sections: [DiffableCollectionSection], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiffableCollectionCellItem>()
        snapshot.appendSections(Array(0..<sections.count))
        
        sections.enumerated().forEach { section in
            snapshot.appendItems(section.element.asItem,
                                 toSection: section.offset)
        }
        dynamicDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func setupCollectionViewLayout(dynamicSections sections: [DiffableCollectionSection]) {
        let layout = UICollectionViewCompositionalLayout { sectionId, env in
            sections[sectionId].sectionLayout
        }
        
        self.setCollectionViewLayout(layout, animated: true)
    }
}


