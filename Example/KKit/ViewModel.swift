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
    @Published private var thirdSectionCount: Int = 2
    @Published private var thirdSection: Section = .thirdRow //.singleRowLayout(width: .absolute(200), height: .absolute(250))
    @Published private var addSecondSection: Bool = false
    
    struct Output {
        let section: AnyPublisher<[DiffableCollectionSection], Never>
    }
    
    enum Section: Int {
        case first, second, thirdCol, thirdRow
    }
    
    func transform() -> Output {
        let sections: AnyPublisher<[DiffableCollectionSection], Never> = Publishers.CombineLatest4($firstSectionCount, $secondSectionCount, $thirdSectionCount, $addSecondSection)
            .combineLatest($thirdSection)
            .map({ ($0.0, $0.1, $0.2, $0.3, $1 )})
            .map({ [weak self] in
                guard let self else { return [] }
                return self.sectionBuilder(firstCount: $0.0, secondCount: $0.1, thirdCount: $0.2, addSecondSection: $0.3, changeThirdSection: $0.4)
            })
            .eraseToAnyPublisher()
        return .init(section: sections)
    }
    
    private func sectionLayout(section: Section) -> NSCollectionLayoutSection {
        switch section {
        case .first:
            return .singleColumnLayout(width: .fractionalWidth(1.0), height: .absolute(100))
        case .second:
            return .singleColumnLayout(width: .fractionalWidth(1), height: .estimated(64))
        case .thirdRow:
            return .singleRowLayout(width: .absolute(200), height: .absolute(250), spacing: 8)
        case .thirdCol:
            return .singleColumnLayout(width: .fractionalWidth(1.0), height: .absolute(250), spacing: 8)
        }
    }
    
    private func sectionBuilder(firstCount: Int, secondCount: Int, thirdCount: Int, addSecondSection: Bool, changeThirdSection: Section) -> [DiffableCollectionSection] {
        
        // MARK: First Section

        let cells = Array(0..<firstCount).map{ DiffableCollectionCell<TestCell>(.init(model: .init(section: 0, item: $0))) }

        let firstSectionLayout: NSCollectionLayoutSection = sectionLayout(section: .first)
            .addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
            .addFooter(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
     
        let header = CollectionSupplementaryView<SectionHeader>(.init(name: "First Section", action: { [weak self] in
            self?.firstSectionCount += 1
        }))
        
        let footer = CollectionSupplementaryView<SectionFooter>(.init(text:"\(addSecondSection ? "Remove" : "Add") Second Section", action: { [weak self] in
            self?.addSecondSection.toggle()
        }))
        
        let firstSection = DiffableCollectionSection(Section.first.rawValue, cells: cells, header: header, footer: footer, sectionLayout: firstSectionLayout)
        
        // MARK: Second Section
        
        let secondSectionLayout: NSCollectionLayoutSection = sectionLayout(section: .second).addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
        
        let sectionTwoCells = Array(0..<secondCount).map{ DiffableCollectionItem<TestSwiftUIView>(.init(section: 1, item: $0)) }
        
        let secondSectionHeader = CollectionSupplementaryView<SectionHeader>(.init(name: "Second Section", action: { [weak self] in
            self?.secondSectionCount += 1
        }))
        
        let secondSection = DiffableCollectionSection(Section.second.rawValue, cells: sectionTwoCells, header: secondSectionHeader, sectionLayout: secondSectionLayout)
        
        // MARK: ThirdSection

        let sectionThreeCells = Array(0..<thirdCount).map{ DiffableCollectionCell<CardCell>(.init(model: .init(section: 2, item: $0))) }

        let thirdSectionLayout: NSCollectionLayoutSection = sectionLayout(section: changeThirdSection)
            .addHeader(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
            .addFooter(size: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
        
        let thirdSectionHeader = CollectionSupplementaryView<LayoutChangingSectionHeader>(.init(name: "Third Section", action: { [weak self] layout in
            self?.thirdSectionCount += 1
        }))
        
        let thirdFooter = CollectionSupplementaryView<SectionFooter>(.init(text:"Change Third Section Layout", action: { [weak self] in
            self?.thirdSection = changeThirdSection == .thirdCol ? .thirdRow : .thirdCol
        }))
        
        let thirdSection = DiffableCollectionSection(changeThirdSection.rawValue, cells: sectionThreeCells, header: thirdSectionHeader, footer: thirdFooter, sectionLayout: thirdSectionLayout)
      
        if addSecondSection {
            return [firstSection, secondSection, thirdSection]
        } else {
            return [firstSection, thirdSection]
        }
       
    }
}
