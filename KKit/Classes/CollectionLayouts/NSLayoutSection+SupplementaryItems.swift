//
//  NSLayoutSection+SupplementaryItems.swift
//  KKit
//
//  Created by Krishna Venkatramani on 02/01/2024.
//

import UIKit

public extension NSCollectionLayoutSection {
    
    static let defaultHeaderSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
    
    @discardableResult
    func addHeader(size: NSCollectionLayoutSize = .defaultHeaderSize, pinHeader: Bool = false) -> Self {
        let header: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = pinHeader
        if self.boundarySupplementaryItems.isEmpty {
            self.boundarySupplementaryItems = [header]
        } else if self.boundarySupplementaryItems.first(where: { $0.elementKind == UICollectionView.elementKindSectionHeader }) == nil {
            self.boundarySupplementaryItems.append(header)
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
