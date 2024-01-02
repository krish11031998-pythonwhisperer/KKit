//
//  CardView.swift
//  KKit_Example
//
//  Created by Krishna Venkatramani on 01/01/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import KKit

struct CardView: ConfigurableView {
    
    private let model: TestHashableModel
    
    init(model: TestHashableModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24, alignment: .center)
            Text("Hello")
            Spacer()
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24, alignment: .center)
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { Color.white }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
    
    static func createContent(with model: TestHashableModel) -> UIContentConfiguration {
        let view = CardView(model: model)
        return UIHostingConfiguration {
            view
        }
    }
    
    static var viewName: String { "CardView" }
}

typealias CardCell = CollectionCellBuilder<CardView>

#Preview {
    CardView(model: .init(section: 0, item: 0))
        .frame(width: 200, height: 275, alignment: .center)
}
