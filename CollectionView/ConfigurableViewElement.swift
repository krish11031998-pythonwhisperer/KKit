//
//  ConfigurableViewElement.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit

// MARK: - ConfigurableViewElement

public protocol ConfigurableViewElement: UIView {
    associatedtype Model
    func configure(with model: Model)
    var inset: UIEdgeInsets { get }
    var background: UIColor { get }
    func prepareViewForReuse()
}

public extension ConfigurableViewElement {
    var inset: UIEdgeInsets { .zero }
    var background: UIColor { .clear }
    func prepareViewForReuse() {}
}


// MARK: - CollectionCellBuilder

public class CollectionCellBuilder<T: ConfigurableViewElement>: DiffableConfigurableCollectionCell {
    
    public typealias Model = CellModel
    
    public struct CellModel: ActionProvider, Hashable {
        
        let model: T.Model
        public var action: Callback?
        
        public init(model: T.Model, action: Callback? = nil) {
            self.model = model
            self.action = action
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(T.name)
            hasher.combine(UUID().uuidString)
        }
        
        public static func == (lhs: CollectionCellBuilder<T>.CellModel, rhs: CollectionCellBuilder<T>.CellModel) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }
    
    private lazy var content: T = { .init() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(content)
        content.fillSuperview(inset: content.inset)
        backgroundColor = content.background
    }
    
    public func configure(with model: CellModel) {
        content.configure(with: model.model)
    }
    
    public static var cellName: String { T.name }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        content.prepareViewForReuse()
    }
    
}

