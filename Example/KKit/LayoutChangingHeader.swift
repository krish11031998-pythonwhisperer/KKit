//
//  LayoutChangingHeader.swift
//  KKit_Example
//
//  Created by Krishna Venkatramani on 12/01/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import KKit

class LayoutChangingSectionHeader: UICollectionReusableView, ConfigurableCollectionSupplementaryView {
    
    enum Layout {
        case column, row
    }
    
    private lazy var headerLabel: UILabel = { .init() }()
    private lazy var addButton: UIButton = { .init() }()
    private var action: ((Layout) -> Void)?
    private var currentLayout: Layout = .row
    
    struct Model: Hashable {
        let name: String
        let action: ((Layout) -> Void)?
        
        static func == (lhs: LayoutChangingSectionHeader.Model, rhs: LayoutChangingSectionHeader.Model) -> Bool {
            lhs.name == rhs.name
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        
        addButton.setFrame(.init(squared: 44))
        addButton.setImage(.init(systemName: "plus")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        addButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        
        let stack = UIStackView.HStack(subViews: [headerLabel, addButton], spacing: 10, alignment: .center)
        
        addSubview(stack)
        stack.fillSuperview()
    }
    
    @objc
    func onTap() {
        print("(DEBUG) Clicked on add!")
        currentLayout = currentLayout == .column ? .row : .column
        action?(currentLayout)
    }
    
    func configure(with model: Model) {
        model.name.styled(.systemFont(ofSize: 24, weight: .bold), color: .black).render(target: headerLabel)
        action = model.action
    }
}

