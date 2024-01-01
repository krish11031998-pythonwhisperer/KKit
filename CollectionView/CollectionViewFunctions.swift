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
