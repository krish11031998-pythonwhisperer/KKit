//
//  DiffableCollectionSupplementaryView.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import UIKit

public protocol CollectionViewSupplementaryView: UICollectionReusableView {
    associatedtype Model: Hashable
    func configure(with model: Model)
}


public protocol CollectionViewSupplementaryViewProvider {
    func registerReusableView(_ cv: UICollectionView, kind: String, indexPath: IndexPath)
    func dequeueReusableView(_ cv: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?
}

public class CollectionSupplementaryView<C: CollectionViewSupplementaryView>: CollectionViewSupplementaryViewProvider {
    
    private let model: C.Model
    
    public init(_ model: C.Model) {
        self.model = model
    }
    
    public func registerReusableView(_ cv: UICollectionView, kind: String, indexPath: IndexPath) {
        cv.register(C.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: C.name)
    }
    
    public func dequeueReusableView(_ cv: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let view = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: C.name, for: indexPath) as? C
        view?.configure(with: model)
        return view
    }
    
}
