//
//  UIView+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 1. 18..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIView {
    var superViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    func screenShot(afterScreenUpdates: Bool = true) -> UIImage? {
        let size = CGSize(width: floor(bounds.size.width), height: floor(bounds.size.height))
        return UIGraphicsImageRenderer(size: size).image { _ in
            drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }

    func rotate(angle: CGFloat) {
        transform = CGAffineTransform.identity

        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = transform.rotated(by: radians)
        transform = rotation
    }

    func roundingCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }

        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    func clearMask() {
        layer.mask = nil
    }

    @discardableResult func add(to view: UIView?) -> Self {
        view?.addSubview(self)
        return self
    }

    static func animate(withDuration duration: TimeInterval,
                              fromView view: UIView,
                              constraints: @escaping () -> Void,
                              animations: (() -> Void)? = nil,
                              completion: ((Bool) -> Void)? = nil) {
        view.layoutIfNeeded()
        constraints()

        UIView.animate(withDuration: duration,
                       animations: {
                        view.layoutIfNeeded()
                        animations?()
        }, completion: completion)
    }
}
#endif
