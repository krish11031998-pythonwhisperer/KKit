//
//  DataSource.swift
//  KKit
//
//  Created by Krishna Venkatramani on 13/01/2024.
//

import UIKit
import Combine

// MARK: - DataSource

public class DataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    private var cellRegistrations: Set<String> = .init()
    
    var sections: [DiffableCollectionSection]
    var datasource: DiffableCollectionDataSource!
    private let prefecthIndex: PassthroughSubject<[IndexPath], Never> = .init()
    private let scrollToEnd: PassthroughSubject<Bool, Never> = .init()
    
    init(sections: [DiffableCollectionSection]) {
        self.sections = sections
    }
    
    func initializeDiffableDataSource(with collectionView: UICollectionView, completion: Callback? = nil) {
        
        // Registering Headers
        sections.enumerated().forEach { section  in
            section.element.registerCells(collectionView: collectionView, cellRegistrationsMap: &cellRegistrations)
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
        collectionView.prefetchDataSource = self
        
        self.applySnapshot(animating: false, completion: completion)
    }
    
    private func setupCollectionViewLayout(newSections: [DiffableCollectionSection]? = nil) -> UICollectionViewCompositionalLayout {
        return  UICollectionViewCompositionalLayout { [weak self] sectionId, env in
            guard let self else { return nil }
            let section = (newSections ?? sections)[sectionId]
            return section.sectionLayout
        }
    }
    
    private func  applySnapshot(animating: Bool = true, completion: Callback? = nil) {
        guard let datasource else { return }
        var snapshot =  CollectionDiffableSnapshot()

        snapshot.appendSections(sections.map(\.id))
        
        sections.indices.forEach { idx in
            let section = sections[idx]
            snapshot.appendItems(section.asItem,
                                 toSection: section.id)
        }
        
        datasource.apply(snapshot, animatingDifferences: animating, completion: completion)
    }
    
    public func reloadSections(collection: UICollectionView, _ sections: [DiffableCollectionSection], completion: Callback? = nil) {
        self.sections = sections
        registerCells(collectionView: collection)
        applySnapshot(animating: true, completion: completion)
        collection.layoutIfNeeded()
    }
    
    public func reloadItems(_ item: DiffableCollectionCellProvider, section: Int, index: Int, alsoReload: Bool) {
        var snapshot = datasource.snapshot()
        
        let id = item.asCellItem
    
        let itemIds = snapshot.itemIdentifiers(inSection: section)
        snapshot.deleteItems([itemIds[index]])
        
        if snapshot.itemIdentifiers(inSection: section).isEmpty {
            snapshot.appendItems([id], toSection: section)
        }
        
        if index == 0, let first = snapshot.itemIdentifiers(inSection: section).first {
            snapshot.insertItems([id], beforeItem: first)
            
        } else if index == (itemIds.count - 1), let last = snapshot.itemIdentifiers(inSection: section).last {
            snapshot.insertItems([id], beforeItem: last)
        } else {
            let currentId = snapshot.itemIdentifiers(inSection: section)[index]
            snapshot.insertItems([id], beforeItem: currentId)
        }
        
        if alsoReload {
            snapshot.reloadItems([id])
        }
        
        datasource.apply(snapshot)
    }
    
    private func registerCells(collectionView: UICollectionView) {
        sections.forEach { section in
            section.registerCells(collectionView: collectionView, cellRegistrationsMap: &cellRegistrations)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].cells[indexPath.item].didSelect(cv: collectionView, indexPath: indexPath)
    }
    
    // MARK: - UICollectionViewPrefetchDelegate
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefecthIndex.send(indexPaths)
        if let lastSection = sections.sorted(by: { $0.id > $1.id }).first {
            
            let lastItem = IndexPath(item: lastSection.cells.count - 1, section: sections.count - 1)
            scrollToEnd.send(indexPaths.contains(where: { $0 == lastItem }))
        }
    }
    
    
    // MARK: - Exposed
    
    var indexToPrefetch: AnyPublisher<[IndexPath], Never> {
        prefecthIndex.eraseToAnyPublisher()
    }
    
    var reachedEnd: AnyPublisher<Bool, Never> {
        scrollToEnd.eraseToAnyPublisher()
    }
}

