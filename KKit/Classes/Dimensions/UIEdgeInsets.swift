//
//  UIEdgeInsets.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 19/09/2022.
//

import Foundation
import UIKit

public extension UIEdgeInsets {
    
    init(by: CGFloat) {
        self.init(top: by, left: by, bottom: by, right: by)
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

//MARK: - NSDirectionEdgeInsets
public extension NSDirectionalEdgeInsets {
    
    init(by: CGFloat) {
        self.init(top: by, leading: by, bottom: by, trailing: by)
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
