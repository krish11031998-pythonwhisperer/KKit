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
    
    private let model: Model
    
    struct Model: Hashable {
        let section: Int
        let item: Int
        let id: Int
        let color: Color
        
        init(section: Int, item: Int, color: Color) {
            self.section = section
            self.item = item
            self.id = section * 10 + item
            self.color = color
        }
    }
    
    init(model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24, alignment: .center)
            Text("Hello")
                .frame(maxHeight: .infinity, alignment: .topLeading)
            //Spacer()
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24, alignment: .center)
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { model.color }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
    
    static func createContent(with model: Model) -> UIContentConfiguration {
        let view = CardView(model: model)
        return UIHostingConfiguration {
            view
        }
    }
    
    static var viewName: String { "CardView" }
}

typealias CardCell = CollectionCellBuilder<CardView>

#Preview {
    CardView(model: .init(section: 0, item: 1, color: .red))
        .frame(width: 200, height: 275, alignment: .center)
}
