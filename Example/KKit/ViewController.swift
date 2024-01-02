//
//  ViewController.swift
//  SUIKit
//
//  Created by 56647167 on 12/25/2023.
//  Copyright (c) 2023 56647167. All rights reserved.
//

import UIKit
import KKit
import Combine

class ViewController: UIViewController {

    private lazy var collectionView: UICollectionView = { .init(frame: .zero, collectionViewLayout: .init()) }()
    @Published private var firstSectionCount: Int = 3
    @Published private var secondSectionCount: Int = 3
    @Published private var thirdSectionCount: Int = 3
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadCollection()
        setupObservers()
    }
    private func setupView() {
        view.addSubview(collectionView)
        collectionView
            .pinAllAnchors()
    }
    
    private func setupObservers() {
        Publishers.MergeMany($firstSectionCount.dropFirst(1), $secondSectionCount.dropFirst(1), $thirdSectionCount.dropFirst(1))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.loadCollection()
            }
            .store(in: &bag)
    }
    
    private func loadCollection() {
        
        // TestCell Section
        
        typealias TestCell = CollectionCellBuilder<TestView>
        
        let cells = Array(0..<firstSectionCount).map{ DiffableCollectionItem<TestCell>(.init(model: .init(section: 0, item: $0))) }
        
        //let cells = firstSectionCells.map{ DiffableCollectionItem<TestCell>(.init(model: $0)) }
        
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.cellName)
        
        let firstSectionLayout: NSCollectionLayoutSection = .singleColumnLayout(width: .fractionalWidth(1.0), height: .absolute(100)).addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
     
        let header = CollectionSupplementaryView<SectionHeader>(.init(name: "First Section", action: { [weak self] in
            self?.firstSectionCount += 1
        }))
        
        let firstSection = DiffableCollectionSection(cells: cells, header: header, sectionLayout: firstSectionLayout)
        
//        collectionView.reloadWithDynamicSection(sections: [firstSection])

        
        typealias TestSwiftUICell = CollectionCellBuilder<TestSwiftUIView>
        
        let secondSectionLayout: NSCollectionLayoutSection = .singleColumnLayout(width: .fractionalWidth(1), height: .estimated(64)).addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
        
        let sectionTwoCells = Array(0..<secondSectionCount).map{ DiffableCollectionItem<TestSwiftUICell>(.init(model: .init(section: 1, item: $0))) }
        
        let secondSectionHeader = CollectionSupplementaryView<SectionHeader>(.init(name: "Second Section", action: { [weak self] in
            self?.secondSectionCount += 1
        }))
        
        collectionView.register(TestSwiftUICell.self, forCellWithReuseIdentifier: TestSwiftUICell.cellName)
        
        let secondSection = DiffableCollectionSection(cells: sectionTwoCells, header: secondSectionHeader, sectionLayout: secondSectionLayout)
        

//        // TestSwiftUICell
    
        typealias CardCell = CollectionCellBuilder<CardView>
        
        let sectionThreeCells = Array(0..<thirdSectionCount).map{ DiffableCollectionItem<CardCell>(.init(model: .init(section: 2, item: $0))) }
        
        let thirdSectionLayout: NSCollectionLayoutSection = .singleRowLayout(width: .absolute(200), height: .absolute(250)).addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.cellName)
        
        let thirdSectionHeader = CollectionSupplementaryView<SectionHeader>(.init(name: "Second Section", action: { [weak self] in
            self?.thirdSectionCount += 1
        }))
        
        let thirdSection = DiffableCollectionSection(cells: sectionThreeCells, header: thirdSectionHeader, sectionLayout: thirdSectionLayout)
        
        
        collectionView.reloadWithDynamicSection(sections: [firstSection, secondSection, thirdSection])
    }
}

