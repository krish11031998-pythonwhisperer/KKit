//
//  ConfigurableViewElement.swift
//  KKit
//
//  Created by Krishna Venkatramani on 29/12/2023.
//

import UIKit
import SwiftUI

// MARK: - CollectionCellBuilder

public class CollectionCellBuilder<T: ConfigurableElement>: DiffableConfigurableCollectionCell {
    
    public typealias Model = CellModel
    
    public struct CellModel: ActionProvider, Hashable {
        
        let model: T.Model
        public var action: Callback?
        
        public init(model: T.Model, action: Callback? = nil) {
            self.model = model
            self.action = action
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(model.hashValue)
        }
        
        public static func == (lhs: CollectionCellBuilder<T>.CellModel, rhs: CollectionCellBuilder<T>.CellModel) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: CellModel) {
        contentConfiguration = T.createContent(with: model.model)
    }
    
    public static var cellName: String { T.viewName }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        //content.prepareViewForReuse()
    }
    
}

