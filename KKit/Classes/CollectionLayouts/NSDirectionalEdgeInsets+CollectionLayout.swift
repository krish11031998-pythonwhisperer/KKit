//
//  NSDirectionalEdgeInsets+CollectionLayout.swift
//  KKit
//
//  Created by Krishna Venkatramani on 20/03/2024.
//

import UIKit

public extension NSCollectionLayoutSection {
    
    enum Insets {
        case group(NSDirectionalEdgeInsets)
        case section(NSDirectionalEdgeInsets)
        case all(NSDirectionalEdgeInsets)
        
        var groupInsets: NSDirectionalEdgeInsets {
            switch self {
            case .group(let insets), .all(let insets):
                return insets
            case .section:
                return .zero
            }
        }
        
        var sectionInsets: NSDirectionalEdgeInsets {
            switch self {
            case .section(let insets), .all(let insets):
                return insets
            case .group:
                return .zero
            }
        }
    }
    
}
