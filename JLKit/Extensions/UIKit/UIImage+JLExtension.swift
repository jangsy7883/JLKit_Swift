//
//  UIImage+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 4. 11..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit)
import UIKit
import Foundation

/*
 참고 : https://github.com/melvitax/ImageHelper
 */
extension UIImage {
    
    public enum UIImageResizeMode {
        case aspectFit
        case aspectFill
        
        func aspectRatio(to size: CGSize, original originalSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/originalSize.width
            let aspectHeight = size.height/originalSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    // MARK:
    
    public func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        let size = CGSize(width: self.size.width + insets.left + insets.right, height: self.size.height + insets.top + insets.bottom)
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        UIGraphicsGetCurrentContext()
        draw(at: CGPoint(x: insets.left, y: insets.top))
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    /*
    public func withTint(_ color: UIColor) -> UIImage? {
        if #available(iOS 13.0, watchOS 6.0, *) {
            return withTintColor(color, renderingMode: .alwaysOriginal)
        }else {
            /*
             let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
             UIGraphicsBeginImageContextWithOptions(size, false, scale)
             color.set()
             UIRectFill(rect)
             draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
             let image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             return image
             */
            defer { UIGraphicsEndImageContext() }
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.set()
            self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
     */
    
    public func withOrientation(_ orientation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation).withRenderingMode(renderingMode)
    }
    
    // MARK:
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        var image: UIImage?
        #if os(iOS)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        #else
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        #endif
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
    
    public func cropToSquare(scale:CGFloat = 1) -> UIImage {
        let shortest = ceil(min(size.width, size.height))
        return resize(to: CGRect(x: 0, y: 0, width: shortest, height: shortest), scale:scale)
    }
    
    // MARK: Resize
    public func resize(toMaxPixel pixel: CGFloat, scale:CGFloat = 1) -> UIImage {
        let hRatio = pixel / size.width
        let vRatio = pixel / size.height
        let ratio = min(hRatio, vRatio)
        return resize(ratio: ratio, scale:scale)
    }

    public func resize(toMinPixel pixel: CGFloat, scale:CGFloat = 1) -> UIImage {
        let hRatio = pixel / size.width
        let vRatio = pixel / size.height
        let ratio = max(hRatio, vRatio)
        return resize(ratio: ratio, scale:scale)
    }
    
    public func resize(_ targetSize: CGSize, resizeMode: UIImageResizeMode = .aspectFill, scale:CGFloat = 1) -> UIImage {
        let ratio = resizeMode.aspectRatio(to: targetSize, original: size)
        return resize(ratio: ratio, scale:scale)
    }
    
    public func resize(ratio:CGFloat, scale:CGFloat = 1) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: ceil(size.width * ratio), height: ceil(size.height * ratio))
        return resize(to: rect, scale:scale)
    }
    
    public func resize(to rect: CGRect, scale:CGFloat = 1) -> UIImage {
        #if os(iOS)
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        
        return UIGraphicsImageRenderer(size: rect.size, format: format).image { _ in
            self.draw(in: rect)
        }
        #else
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        self.draw(in: rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return image
        #endif
    }
}

public extension UIImage {
    var bytesSize: Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }

    var kilobytesSize: Int {
        return (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    enum ImageFormat {
        case JPEG(compressionQuality: CGFloat)
        case PNG
    }

    func data(_ format: ImageFormat) -> Data? {
        return autoreleasepool { () -> Data? in
            let data: Data?
            switch format {
            case .PNG: data = pngData()
            case .JPEG(let compressionQuality): data = jpegData(compressionQuality: compressionQuality)
            }
            return data
        }
    }
}

public extension UIImage {

    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }

    #if canImport(CoreImage)
    func averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert pixel data to UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }
    #endif
}

public extension UIImage {
    #if os(iOS)
    static func dynamicImage(withLight light: @autoclosure () -> UIImage?,
                             dark: @autoclosure () -> UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            let lightTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .light)])
            let darkTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .dark)])
            
            var lightImage:UIImage?
            var darkImage:UIImage?
            
            lightTC.performAsCurrent {
                lightImage = light()
            }
            darkTC.performAsCurrent {
                darkImage = dark()
            }
            
            if let darkImage {
                lightImage?.imageAsset?.register(darkImage, with: UITraitCollection(userInterfaceStyle: .dark))
            }
            return lightImage
        } else {
            return light()
        }
    }
    #endif
}

#endif
