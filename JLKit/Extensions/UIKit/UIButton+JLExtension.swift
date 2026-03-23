//
//  UIButton+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIButton {
    @objc func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        guard let color = color else { return }

        setBackgroundImage(UIImage(color: color), for: state)
    }

    @objc @discardableResult func withCenterVertically(_ padding: Float) -> UIButton {
        guard let imageSize = imageView?.frame.size else { return self }
        guard let titleSize = titleLabel?.frame.size else { return self }

        let totalHeight = imageSize.height + titleSize.height + CGFloat(padding)

        imageEdgeInsets = UIEdgeInsets(top: -CGFloat(floorf(Float(totalHeight - imageSize.height))),
                                       left: 0.0,
                                       bottom: 0.0,
                                       right: -CGFloat(floorf(Float(titleSize.width))))

        titleEdgeInsets = UIEdgeInsets(top: 0.0,
                                       left: -CGFloat(floorf(Float(imageSize.width))),
                                       bottom: -CGFloat(floorf(Float(totalHeight - titleSize.height))),
                                       right: 0.0)
        return self
    }

    @objc func setTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        removeTarget(target, action: nil, for: controlEvents)
        addTarget(target, action: action, for: controlEvents)
    }
}
#endif
