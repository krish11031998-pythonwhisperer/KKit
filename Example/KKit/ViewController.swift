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
    private let viewModel: ViewModel = .init()
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
    
    private func loadCollection() {
        
        // TestCell Section
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.cellName)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.cellName)
        
    }
    
    private func setupObservers() {
        
        viewModel.transform().section
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.collectionView.reloadWithDynamicSection(sections: sections) {
                    self?.afterReloading()
                }
            }
            .store(in: &bag)
    }
    
    private func afterReloading() {
        collectionView.prefetchIndexPath?
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink {
                print("(DEBUG) indexPath: ", $0)
            }
            .store(in: &bag)
        
        collectionView.reachedEnd?
            .filter({ $0 })
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("(DEBUG) reachedEnd!")
            }
            .store(in: &bag)
    }
    
}

