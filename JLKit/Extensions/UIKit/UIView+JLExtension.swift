//
//  UIView+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 18..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

extension UIView {
    @objc public static var className: String {
        get {
            return String(describing: self.self)
        }
    }

    @objc public var superViewController : UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    @objc public func screenShot(afterScreenUpdates:Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    @objc public func rotate(angle: CGFloat) {
        transform = CGAffineTransform.identity

        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = transform.rotated(by: radians)
        transform = rotation
    }

    @objc public func roundingCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    @objc public func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }

        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }

    @objc public func clearMask() {
        self.layer.mask = nil
    }
}
