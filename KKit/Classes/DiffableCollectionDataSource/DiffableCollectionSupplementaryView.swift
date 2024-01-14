//
//  DiffableCollectionSupplementaryView.swift
//  KKit
//
//  Created by Krishna Venkatramani on 01/01/2024.
//

import UIKit

public protocol ConfigurableCollectionSupplementaryView: UICollectionReusableView {
    associatedtype Model: Hashable
    func configure(with model: Model)
}


public protocol CollectionSupplementaryViewProvider: Hashable, Equatable {
    func registerReusableView(_ cv: UICollectionView, kind: String, indexPath: IndexPath)
    func dequeueReusableView(_ cv: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?
}

public class CollectionSupplementaryView<C: ConfigurableCollectionSupplementaryView>: CollectionSupplementaryViewProvider {
    
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
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model.hashValue)
    }
    
    public static func == <A: ConfigurableCollectionSupplementaryView, B: ConfigurableCollectionSupplementaryView>(lhs: CollectionSupplementaryView<A>, rhs: CollectionSupplementaryView<B>) -> Bool {
        guard A.self == B.self, A.Model.self == B.Model.self else { return false }
        return lhs.model.hashValue == rhs.model.hashValue
    }
    
}
