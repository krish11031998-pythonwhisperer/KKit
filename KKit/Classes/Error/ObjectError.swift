//
//  ObjectError.swift
//  KKit
//
//  Created by Krishna Venkatramani on 31/01/2024.
//

import Foundation

public enum ObjectError: String, Error {
    case objectOutOfMemory
}

public enum TickerError: String {
    case ticker = "No Info received from error"
}

extension TickerError: StandardError {
    public var errorDescription: String? { self.rawValue }
}
