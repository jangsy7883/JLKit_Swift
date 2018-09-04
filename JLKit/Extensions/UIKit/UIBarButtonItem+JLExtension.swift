//
//  UIBarButtonItem+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 5. 10..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

extension UIBarButtonItem {

    convenience init(customImage: UIImage?, highlightedImage: UIImage? = nil, contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3), target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setImage(customImage, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        button.contentEdgeInsets = contentEdgeInsets
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        if let window = UIApplication.shared.delegate?.window, let tineColor = window?.tintColor {            
            button.tintColor = tineColor
        }
        self.init(customView: button)
    }
    
    convenience init(fixedSpace:CGFloat){
        self.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        self.width = fixedSpace
    }
}
