//
//  ArrayExtension.swift
//  KKit
//
//  Created by Krishna Venkatramani on 25/01/2024.
//

import Foundation

public extension Array {
    func limit(from: Int = 0, to: Int) -> [Self.Element] {
        guard from < count - 1 else { return self }
        return to <= count - 1 ? Array(self[from..<to]) : self
    }
}
