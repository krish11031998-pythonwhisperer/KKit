//
//  Double.swift
//  KKit
//
//  Created by Krishna Venkatramani on 27/12/2023.
//

import Foundation

//MARK: - Array + Double

public extension Array where Self.Element == Double {
    func normalize() -> [Self.Element] {
        guard let max = self.max(), let min = self.min() else { return self }
        return map { ($0 - min)/(max - min) }
    }
    
    func avg() -> Self.Element {
        reduce(0, { $0 + $1 })/Double(count)
    }
}
