//
//  UIImageView+Extension.swift
//  KKit
//
//  Created by Krishna Venkatramani on 13/02/2024.
//

import Foundation
import UIKit

public extension UIImageView {
    
    static func standardImageView(frame: CGRect = .zero,
                                  dimmingForeground: Bool = false,
                                  circleFrame: Bool = false,
                                  contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImageView {
        var imageView: UIImageView
        if circleFrame {
            imageView = .init(frame: frame)
            imageView.cornerRadius = frame.size.smallDim.half
        } else {
            imageView = .init(frame: frame)
        }
        imageView.clipsToBounds = true
        imageView.contentMode = contentMode
        if dimmingForeground {
            let view = UIView()
            view.backgroundColor = .black.withAlphaComponent(0.2)
            imageView.addSubview(view)
            imageView.setFittingConstraints(childView: view, insets: .zero)
        }
        return imageView
    }
}
