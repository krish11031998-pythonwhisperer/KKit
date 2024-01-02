//
//  NSLayoutSection+SupplementaryItems.swift
//  KKit
//
//  Created by Krishna Venkatramani on 02/01/2024.
//

import UIKit

public extension NSCollectionLayoutSection {
    
    @discardableResult
    func addHeader(size: NSCollectionLayoutSize) -> Self {
        self.boundarySupplementaryItems = [.init(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        return self
    }
    
    @discardableResult
    func addFooter(size: NSCollectionLayoutSize) -> Self {
        self.boundarySupplementaryItems = [.init(layoutSize: size, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)]
        return self
    }
}
