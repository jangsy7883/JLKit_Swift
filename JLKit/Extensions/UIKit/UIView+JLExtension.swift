//
//  UIView+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 18..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

extension UIView {
    @objc class var className: String {
        get {
            return String(describing: self.self)
        }
    }

    func rotate(angle: CGFloat) {
        transform = CGAffineTransform.identity

        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = transform.rotated(by: radians)
        transform = rotation
    }

    func roundingCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }

        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }

    func clearMask() {
        self.layer.mask = nil
    }
}
