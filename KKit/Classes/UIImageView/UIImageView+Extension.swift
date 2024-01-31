//
//  UIImageView+Extension.swift
//  KKit
//
//  Created by Krishna Venkatramani on 31/01/2024.
//

import UIKit

//MARK: - Helpers
public extension UIImage {

    func resized(size newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in self.draw(in: CGRect(origin: .zero, size: newSize)) }
        let newImage = image.withRenderingMode(renderingMode)
        return newImage
    }
    
    func resized(withAspect to: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: to)
        let newSize = resolveWithAspectRatio(newSize: to)
        let newOrigin: CGPoint = .init(x: (to.width - newSize.width).half , y: (to.height - newSize.height).half)
        let img = renderer.image { _ in self.draw(in: .init(origin: newOrigin, size: newSize))}
        return img
    }
    
    func scaleImageToNewSize(newSize: CGSize) -> UIImage {
        let ratio = size.width/size.height
        var scaledSize: CGSize = .zero
        if size.height < size.width {
            scaledSize = .init(width: ratio * newSize.height, height: newSize.height)
        } else {
            scaledSize = .init(width: newSize.width, height: newSize.width/ratio)
        }
        return resized(size: scaledSize)
    }
    
    func resolveWithAspectRatio(newSize: CGSize) -> CGSize {
        
        let ratio = size.width/size.height
        
        if size.width < size.height {
            let newHeight = min(size.height, newSize.height)
            return .init(width: newHeight * ratio, height: newHeight)
            
        } else {
            let newWidth = min(size.width, newSize.width)
            return .init(width: newWidth, height: newWidth/ratio)
        }
    }
    
    func imageView(size: CGSize? = nil, resized: Bool = true, cornerRadius: CGFloat = .zero) -> UIImageView {
        let view = UIImageView(frame: (size ?? self.size).bounds)
        if let size = size, resized {
            view.image = self.resized(size: size)
        } else {
            view.image = self
        }
        
        view.contentMode = .scaleAspectFit
        view.clippedCornerRadius = cornerRadius
        return view
    }
    
    static func solidColor(color: UIColor, frame: CGSize = .smallestSquare) -> UIImage {
        let view = UIView(frame: .init(origin: .zero, size: frame))
        view.backgroundColor = color
        return view.snapshot
    }
    
    
    static func solid(color: UIColor, circleFrame frame: CGSize = .smallestSquare) -> UIImage {
        let view = UIView(frame: .init(origin: .zero, size: frame))
        view.clippedCornerRadius = frame.smallDim.half
        view.backgroundColor = color
        return view.snapshot
    }
    
    
    static let placeHolder: UIImage = .solidColor(color: .gray, frame: .init(squared: 100))
        
}
