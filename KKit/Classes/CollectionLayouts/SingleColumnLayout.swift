//
//  SingleColumnLayout.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import UIKit

public extension NSCollectionLayoutSection {
    
    static func singleColumnLayout(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, insets: NSDirectionalEdgeInsets = .init(by: 10), spacing: CGFloat = 8) -> NSCollectionLayoutSection {
        let size: NSCollectionLayoutSize = .init(widthDimension: width, heightDimension: height)
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        
        layoutSection.contentInsets = insets
        
        layoutSection.interGroupSpacing = spacing
        
        return layoutSection
    }
    
}
