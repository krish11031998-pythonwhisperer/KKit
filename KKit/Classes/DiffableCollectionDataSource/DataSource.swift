//
//  DataSource.swift
//  KKit
//
//  Created by Krishna Venkatramani on 13/01/2024.
//

import UIKit

// MARK: - DataSource

public class DataSource: NSObject, UICollectionViewDelegate {
    
    var sections: [DiffableCollectionSection]
    var datasource: DiffableCollectionDataSource!
    
    init(sections: [DiffableCollectionSection]) {
        self.sections = sections
    }
    
    func initializeDiffableDataSource(with collectionView: UICollectionView) {
        
        // Registering Headers
        sections.enumerated().forEach { section  in
            section.element.header?.registerReusableView(collectionView, kind: UICollectionView.elementKindSectionHeader, indexPath: .init(item: 0, section: section.offset))
            section.element.footer?.registerReusableView(collectionView, kind: UICollectionView.elementKindSectionFooter, indexPath: .init(item: 0, section: section.offset))
        }
        
        datasource = DiffableCollectionDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch item {
            case .view(let cell):
                cell.cell(cv: collectionView, indexPath: indexPath)
            case .item(let item):
                item.cell(cv: collectionView, indexPath: indexPath)
            }
        }
        
        datasource.supplementaryViewProvider = ({ [weak self] cv, kind, index in
            guard let self else { return nil }
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return self.sections[index.section].header?.dequeueReusableView(cv, kind: kind, indexPath: index)
            case UICollectionView.elementKindSectionFooter:
                return self.sections[index.section].footer?.dequeueReusableView(cv, kind: kind, indexPath: index)
            default:
                return nil
            }
        })
        
        // Setting Layout
        collectionView.setCollectionViewLayout(setupCollectionViewLayout(), animated: false)
        collectionView.delegate = self
        
        self.applySnapshot(animating: false)
    }
    
    private func setupCollectionViewLayout(newSections: [DiffableCollectionSection]? = nil) -> UICollectionViewCompositionalLayout {
        return  UICollectionViewCompositionalLayout { [weak self] sectionId, env in
            guard let self else { return nil }
            let section = (newSections ?? sections)[sectionId]
            return section.sectionLayout
        }
    }
    
    private func  applySnapshot(animating: Bool = true) {
        guard let datasource else { return }
        var snapshot =  CollectionDiffableSnapshot()

        snapshot.appendSections(sections.map(\.id))
        
        sections.indices.forEach { idx in
            let section = sections[idx]
            snapshot.appendItems(section.asItem,
                                 toSection: section.id)
        }
        
        datasource.apply(snapshot, animatingDifferences: animating)
    }
    
    public func reloadSections(collection: UICollectionView, _ sections: [DiffableCollectionSection]) {
        self.sections = sections
        applySnapshot(animating: true)
        collection.layoutIfNeeded()
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].cells[indexPath.item].didSelect(cv: collectionView, indexPath: indexPath)
    }
}

