//
//  ViewController.swift
//  SUIKit
//
//  Created by 56647167 on 12/25/2023.
//  Copyright (c) 2023 56647167. All rights reserved.
//

import UIKit
import KKit

class ViewController: UIViewController {

    private lazy var collectionView: UICollectionView = { .init(frame: .zero, collectionViewLayout: .init()) }()
    private var count: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
        loadCollection()
    }
    private func setupView() {
        view.addSubview(collectionView)
        collectionView
            .pinAllAnchors()
    }
    
    private func loadCollection() {
        
        let size: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        
        layoutSection.contentInsets = .init(by: 10)
        
        layoutSection.interGroupSpacing = 8
        
        typealias Cell = CollectionCellBuilder<TestView>
        
        let cells = Array(0..<count).map{ _ in DiffableCollectionItem<Cell>(.init(model: .init())) }
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.cellName)
        
        let section = DiffableCollectionSection(cells: cells, sectionLayout: layoutSection)
        
        collectionView.reloadWithDynamicSection(sections: [section])
    }
}

