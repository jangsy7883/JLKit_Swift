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

    public var superViewController : UIViewController? {
        var view :UIView?  = self
        while view != nil {
            if let viewController = view?.next as? UIViewController {
                return viewController
            }else {
                view = view?.superview
            }
        }
        return nil
    }
    
    
    public func screenShot(afterScreenUpdates:Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    public func rotate(angle: CGFloat) {
        transform = CGAffineTransform.identity

        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = transform.rotated(by: radians)
        transform = rotation
    }

    public func roundingCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    public func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }

        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }

    public func clearMask() {
        self.layer.mask = nil
    }
}
