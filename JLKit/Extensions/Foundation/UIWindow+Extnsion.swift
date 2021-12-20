//
//  UIWindow+Extnsion.swift
//  TheCouple
//
//  Created by 장석용 on 2021/12/03.
//  Copyright © 2021 TheDayBefore. All rights reserved.
//

import UIKit

public extension UIWindow {
    static var root: UIWindow? {
        (UIApplication.shared.delegate as? AppDelegate)?.window
    }
}
