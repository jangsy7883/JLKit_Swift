//
//  UIBarButtonItem+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 5. 10..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if os(iOS)
import UIKit

public extension UIBarButtonItem {
    static var flexibleSpace: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}

extension UIBarButtonItem {

    @objc public convenience init(customImage: UIImage?, highlightedImage: UIImage? = nil, contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3), target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setImage(customImage, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        button.contentEdgeInsets = contentEdgeInsets
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        let selector = NSSelectorFromString("sharedApplication")
        if let application =  UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication,
           let window = application.delegate?.window, let tineColor = window?.tintColor {
            
            button.tintColor = tineColor
        }
        
        button.sizeToFit()
        self.init(customView: button)
    }
    
    @objc public convenience init(fixedSpace:CGFloat){
        self.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        self.width = fixedSpace
    }
}
#endif
