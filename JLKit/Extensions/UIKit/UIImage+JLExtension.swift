//
//  UIImage+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 4. 11..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

/*
 참고 : https://github.com/melvitax/ImageHelper
 */
extension UIImage {
    
    public enum UIImageResizeMode {
        case aspectFit
        case aspectFill
        case scaleToFill
        
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .scaleToFill:
                return 1
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    public func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        let size = CGSize(width: self.size.width + insets.left + insets.right, height: self.size.height + insets.top + insets.bottom)
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        UIGraphicsGetCurrentContext()
        draw(at: CGPoint(x: insets.left, y: insets.top))
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    public func withTint(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        UIRectFill(rect)
        draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func withOrientation(_ orientation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {return nil}
        
        self.init(cgImage: cgImage)
    }
    
    // MARK: Crop
    
    public func crop(bounds: CGRect) -> UIImage? {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }
    
    public func cropToSquare() -> UIImage? {
        let shortest = min(size.width, size.height)
        return resize(toSize: CGSize(width: shortest, height: shortest), resizeMode: .aspectFill)
    }
    
    // MARK: Resize
    public func resize(toMaxLength: CGFloat) -> UIImage? {
        let horizontalRatio = toMaxLength / size.width
        let verticalRatio = toMaxLength / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        
        let toSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        return resize(toSize: toSize, resizeMode: .scaleToFill)
    }
    
    public func resize(toSize: CGSize, resizeMode: UIImageResizeMode = .aspectFill) -> UIImage? {
        
        var rect = CGRect.zero
        
        if resizeMode == .scaleToFill {
            rect.size = toSize
        } else {
            let aspectRatio = resizeMode.aspectRatio(between: toSize, and: size)
            
            rect.size.width  = size.width * aspectRatio
            rect.size.height = size.height * aspectRatio
            rect.origin.x    = (toSize.width - size.width * aspectRatio) / 2.0
            rect.origin.y    = (toSize.height - size.height * aspectRatio) / 2.0
        }
        
        UIGraphicsBeginImageContext(toSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
