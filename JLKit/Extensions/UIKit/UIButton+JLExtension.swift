//
//  UIButton+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UIButton {

    public func setBackgroundColor(_ color: UIColor?, for state: UIControlState) {
        guard let color = color else { return }
        setBackgroundImage(UIImage(color: color), for: state)
    }
    
    
    public func withCenterVertically(_ padding:Float) -> UIButton {
        guard let imageSize = self.imageView?.frame.size else { return self }
        guard let titleSize = self.titleLabel?.frame.size else { return self }
        
        let totalHeight = imageSize.height + titleSize.height + CGFloat(padding)

        self.imageEdgeInsets = UIEdgeInsetsMake(-CGFloat(floorf(Float(totalHeight - imageSize.height))),
                                                0.0,
                                                0.0,
                                                -CGFloat(floorf(Float(titleSize.width))));

        self.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                -CGFloat(floorf(Float(imageSize.width))),
                                                -CGFloat(floorf(Float(totalHeight - titleSize.height))),
                                                0.0);
        return self
    }
    
    public func setTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        removeTarget(target, action: nil, for: controlEvents)
        addTarget(target, action: action, for: controlEvents)
    }
}
