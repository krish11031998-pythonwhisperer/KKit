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
        if self.boundarySupplementaryItems.isEmpty {
            self.boundarySupplementaryItems = [.init(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        } else if self.boundarySupplementaryItems.first(where: { $0.elementKind == UICollectionView.elementKindSectionHeader }) == nil {
            self.boundarySupplementaryItems.append(.init(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top))
        }
        
        return self
    }
    
    @discardableResult
    func addFooter(size: NSCollectionLayoutSize) -> Self {
        if self.boundarySupplementaryItems.isEmpty {
            self.boundarySupplementaryItems = [.init(layoutSize: size, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)]
        } else if self.boundarySupplementaryItems.first(where: { $0.elementKind == UICollectionView.elementKindSectionFooter }) == nil {
            self.boundarySupplementaryItems.append(.init(layoutSize: size, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom))
        }
        return self
    }
}
