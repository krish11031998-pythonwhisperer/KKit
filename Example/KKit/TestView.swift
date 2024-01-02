//
//  TestView.swift
//  SUIKit_Example
//
//  Created by Krishna Venkatramani on 27/12/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import KKit

struct TestHashableModel: Hashable {
    let section: Int
    let item: Int
    let id: Int
    public init(section: Int, item: Int) {
        self.id = item + section * 10
        self.section = section
        self.item = item
    }
}

class TestView: ConfigurableUIView {
    
    private var largeViewWidthConstraint: NSLayoutConstraint!
    private var secondLargeViewHeightConstraint: NSLayoutConstraint!
    
    private lazy var largeSimpleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var secondLargeSimpleView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var smallSimpleView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        largeViewWidthConstraint.constant = bounds.width.half
        secondLargeViewHeightConstraint.constant = bounds.height * 0.6
    }
    
    private func setupView() {
        [largeSimpleView, secondLargeSimpleView, smallSimpleView].forEach(addSubview(_:))
        
        largeSimpleView
            .pinTopAnchorTo(constant: 0)
            .pinLeadingAnchorTo(constant: 0)
            .pinBottomAnchorTo(constant: 0)
        
        secondLargeSimpleView
            .pinTopAnchorTo(constant: 0)
            .pinLeadingAnchorTo(largeSimpleView, anchor: \.trailingAnchor, constant: 0)
            .pinTrailingAnchorTo(constant: 0)
        
        smallSimpleView
            .pinTopAnchorTo(secondLargeSimpleView, anchor: \.bottomAnchor, constant: 0)
            .pinLeadingAnchorTo(largeSimpleView, anchor: \.trailingAnchor, constant: 0)
            .pinTrailingAnchorTo(constant: 0)
            .pinBottomAnchorTo(constant: 0)
        
        largeViewWidthConstraint = largeSimpleView.setWidth(width: 0)
        secondLargeViewHeightConstraint = secondLargeSimpleView.setHeight(height: 0)
        
    }
        
    static func createContent(with model: TestHashableModel) -> UIContentConfiguration {
        let view = TestView()
        return UIViewConfiguration(view: view)
    }
    
    static var viewName: String { name }
}

@available(iOS 17.0, *)
#Preview("Test", traits: .fixedLayout(width: 300, height: 500), body: {
    let view = TestView()
    return view
})
