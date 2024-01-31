//
//  UIButton+Publishers.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 13/01/2023.
//

import Foundation
import Combine
import UIKit

public extension UIButton {
    
    var tapPublisher: VoidPublisher { self.publisher(for: .touchUpInside).map { _ in () }.eraseToAnyPublisher() }
    
}
