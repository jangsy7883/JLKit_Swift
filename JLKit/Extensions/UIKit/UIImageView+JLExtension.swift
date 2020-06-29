//
//  UIImageView+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2020/06/29.
//  Copyright © 2020 Woody. All rights reserved.
//

import UIKit

extension UIImageView {
    public convenience init(image: UIImage?, tintColor: UIColor) {
        self.init(image: image?.withRenderingMode(.alwaysTemplate))
        self.tintColor = tintColor
    }
}
