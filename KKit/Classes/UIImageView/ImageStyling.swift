//
//  ImageStyling.swift
//  KKit
//
//  Created by Krishna Venkatramani on 13/02/2024.
//

import Foundation
import UIKit

public struct ImageStyling {
    let size: CGSize
    let imgSize: CGSize
    let cornerRadius: CGFloat
    let bordered: Bool
    let borderColor: UIColor
    let borderWidth: CGFloat
    let bgColor: UIColor
    let contentMode: UIView.ContentMode
    
    public init(size: CGSize,
         cornerRadius: CGFloat = 0,
         bordered: Bool = false,
         borderColor: UIColor = .clear,
         borderWidth: CGFloat = 0,
         bgColor: UIColor = .clear,
         contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.size = size
        self.imgSize = size
        self.cornerRadius = cornerRadius
        self.bordered = bordered
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.bgColor = bgColor
        self.contentMode = contentMode
    }
    
    public init(size: CGSize,
         imgSize: CGSize,
         cornerRadius: CGFloat = 0,
         bordered: Bool = false,
         borderColor: UIColor = .clear,
         borderWidth: CGFloat = 0,
         bgColor: UIColor = .clear,
         contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.size = size
        self.imgSize = imgSize
        self.cornerRadius = cornerRadius
        self.bordered = bordered
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.bgColor = bgColor
        self.contentMode = contentMode
    }
}

//MARK: - ImageStyling Extension
public extension ImageStyling {
    
    func stylize(on image: UIImageView) {
        image.setFrame(size)
        image.contentMode = contentMode
        image.clippedCornerRadius = cornerRadius
        image.backgroundColor = bgColor
        image.image = image.image?.resized(size: imgSize)
        if bordered {
            let borderLayer = CAShapeLayer()
            borderLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: size),
                                            cornerRadius: cornerRadius).cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.borderColor = borderColor.cgColor
            borderLayer.borderWidth = borderWidth
            image.layer.addSublayer(borderLayer)
        }
    }
    
}
