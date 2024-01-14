//
//  SectionFooter.swift
//  KKit_Example
//
//  Created by Krishna Venkatramani on 13/01/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import KKit

class SectionFooter: UICollectionReusableView, ConfigurableCollectionSupplementaryView {
    
    struct Model: Hashable {
        
        var id: UUID
        var text: String
        var action: Callback?
        
        init(id: UUID = .init(), text: String, action: Callback? = nil) {
            self.id = id
            self.text = text
            self.action = action
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: SectionFooter.Model, rhs: SectionFooter.Model) -> Bool {
            lhs.id == rhs.id
        }
        
    }
    
    private lazy var label: UILabel = { .init() }()
    private lazy var plusIcon: UIImageView = {
        let image = UIImageView()
        image.image = .init(systemName: "plus")
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        return image
    }()
    private var action: Callback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stack = UIStackView.HStack(subViews: [label, plusIcon], spacing: 8, alignment: .center)
    
        addSubview(stack)
        stack.tapGesture { [weak self] in
            guard let self, let action = self.action else { return }
            action()
        }
        stack.pinVerticalAnchorsTo(constant: 0)
            .pinCenterXAnchorTo(constant: 0)
    }
    
    
    func configure(with model: Model) {
        self.action = model.action
        model.text.styled(.attributed(font: .systemFont(ofSize: 16, weight: .medium))).render(target: label)
    }
}
