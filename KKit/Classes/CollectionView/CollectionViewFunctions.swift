//
//  CollectionViewFunctions.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit
import Combine

extension UICollectionView {
    
    func dequeueCell<C: DiffableConfigurableCollectionCell>(name: String = C.cellName, indexPath: IndexPath) -> C? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? C else {
            register(C.self, forCellWithReuseIdentifier: C.name)
            return dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? C ?? C()
        }
        
        return cell
    }
}

// MARK: - UICollectionView

public extension UICollectionView {
    
    static var dynamicDataSourceObject: [UICollectionView:DataSource] = [:]
    
    var dynamicDataSource: DataSource? {
        get { Self.dynamicDataSourceObject[self] }
        set { Self.dynamicDataSourceObject[self] = newValue }
    }
    
    var prefetchIndexPath: AnyPublisher<[IndexPath], Never>? {
        dynamicDataSource?.indexToPrefetch
    }
    
    var reachedEnd: AnyPublisher<Bool, Never>? {
        dynamicDataSource?.reachedEnd
    }
    
    func reloadWithDynamicSection(sections: [DiffableCollectionSection], completion: Callback? = nil) {
        
        if let source = self.dynamicDataSource {
            source.reloadSections(collection: self, sections, completion: completion)
            return
        }
        
        self.dynamicDataSource = DataSource(sections: sections)
        dynamicDataSource!.initializeDiffableDataSource(with: self, completion: completion)
    }
    
    func reloadItems(_ item: DiffableCollectionCellProvider, section: Int, index: Int, alsoReload: Bool = true) {
        guard let datasource = dynamicDataSource else  { return }
        
        datasource.reloadItems(item, section: section, index: index, alsoReload: alsoReload)
    }
}

