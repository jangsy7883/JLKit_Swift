//
//  UIImage+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 4. 11..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

/*
 참고 : https://github.com/melvitax/ImageHelper
 */
extension UIImage {
    public enum UIImageContentMode {
        case scaleToFill, scaleAspectFit, scaleAspectFill
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

    public func withOrientation(_ orientation: UIImageOrientation) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
    }

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        var image: UIImage? = nil
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
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)

        let left: CGFloat = (size.width > shortest) ? (size.width - shortest) / 2 : 0
        let top: CGFloat = (size.height > shortest) ? (size.height - shortest) / 2 : 0

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = rect.insetBy(dx: left, dy: top)

        return crop(bounds: insetRect)
    }

    // MARK: Resize

    public func resize(toSize: CGSize, contentMode: UIImageContentMode = .scaleToFill) -> UIImage? {
        let horizontalRatio = toSize.width / size.width
        let verticalRatio = toSize.height / size.height
        var ratio: CGFloat!

        switch contentMode {
        case .scaleToFill:
            ratio = 1
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)

        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        let transform = CGAffineTransform.identity

        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform)

        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality(rawValue: 3)!

        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))

        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)

        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage
    }
}
