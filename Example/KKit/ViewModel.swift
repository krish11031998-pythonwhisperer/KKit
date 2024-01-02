//
//  ViewModel.swift
//  KKit_Example
//
//  Created by Krishna Venkatramani on 02/01/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Combine
import KKit

class ViewModel {
    
    @Published private var firstSectionCount: Int = 3
    @Published private var secondSectionCount: Int = 3
    @Published private var thirdSectionCount: Int = 3
        
    struct Output {
        let section: AnyPublisher<[DiffableCollectionSection], Never>
    }
    
    func transform() -> Output {
        let sections: AnyPublisher<[DiffableCollectionSection], Never> = Publishers.CombineLatest3($firstSectionCount, $secondSectionCount, $thirdSectionCount)
            .map({ [weak self] (first, second, third) in
                guard let self else { return [] }
                return self.sectionBuilder(firstSectionCount: first, secondSectionCount: second, thirdSectionCount: third)
            })
            .eraseToAnyPublisher()
        return .init(section: sections)
    }
    
    private func sectionBuilder(firstSectionCount: Int, secondSectionCount: Int, thirdSectionCount: Int) -> [DiffableCollectionSection] {
        // TestCell Section

        let cells = Array(0..<firstSectionCount).map{ DiffableCollectionItem<TestCell>(.init(model: .init(section: 0, item: $0))) }

        let firstSectionLayout: NSCollectionLayoutSection = .singleColumnLayout(width: .fractionalWidth(1.0), height: .absolute(100)).addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
     
        let header = CollectionSupplementaryView<SectionHeader>(.init(name: "First Section", action: { [weak self] in
            self?.firstSectionCount += 1
        }))
        
        let firstSection = DiffableCollectionSection(cells: cells, header: header, sectionLayout: firstSectionLayout)
        
        // TestSwiftUI Section
        
        let secondSectionLayout: NSCollectionLayoutSection = .singleColumnLayout(width: .fractionalWidth(1), height: .estimated(64)).addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
        
        let sectionTwoCells = Array(0..<secondSectionCount).map{ DiffableCollectionItem<TestSwiftUICell>(.init(model: .init(section: 1, item: $0))) }
        
        let secondSectionHeader = CollectionSupplementaryView<SectionHeader>(.init(name: "Second Section", action: { [weak self] in
            self?.secondSectionCount += 1
        }))
        
        let secondSection = DiffableCollectionSection(cells: sectionTwoCells, header: secondSectionHeader, sectionLayout: secondSectionLayout)
        
        // TestSwiftUICell

        let sectionThreeCells = Array(0..<thirdSectionCount).map{ DiffableCollectionItem<CardCell>(.init(model: .init(section: 2, item: $0))) }
        
        let thirdSectionLayout: NSCollectionLayoutSection = .singleRowLayout(width: .absolute(200), height: .absolute(250)).addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
        
        let thirdSectionHeader = CollectionSupplementaryView<SectionHeader>(.init(name: "Third Section", action: { [weak self] in
            self?.thirdSectionCount += 1
        }))
        
        let thirdSection = DiffableCollectionSection(cells: sectionThreeCells, header: thirdSectionHeader, sectionLayout: thirdSectionLayout)
        
        return [firstSection, secondSection, thirdSection]
    }
}
