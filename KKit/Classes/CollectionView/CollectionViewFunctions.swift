//
//  CollectionViewFunctions.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit

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
    
    
    func reloadWithDynamicSection(sections: [DiffableCollectionSection]) {
        
        if let source = self.dynamicDataSource {
            source.reloadSections(collection: self, sections)
            return
        }
        
        self.dynamicDataSource = DataSource(sections: sections)
        dynamicDataSource!.initializeDiffableDataSource(with: self)
    }
}

