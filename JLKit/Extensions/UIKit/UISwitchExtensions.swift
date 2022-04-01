//
//  UISwitchExtensions.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2022/04/01.
//  Copyright © 2022 Woody. All rights reserved.
//

#if canImport(UIKit) && os(iOS)
import UIKit

public extension UISwitch {

    func toggle(animated: Bool = true) {
        setOn(!isOn, animated: animated)
    }
}

#endif
