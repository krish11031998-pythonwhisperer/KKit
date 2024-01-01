//
//  File.swift
//  Pods-SUIKit_Example
//
//  Created by Krishna Venkatramani on 27/12/2023.
//

import Foundation


// MARK: - Callback

public typealias Callback = () -> Void


// MARK: - ActionProvider

public protocol ActionProvider {
    var action: Callback? { get set }
}
