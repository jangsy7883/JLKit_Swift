//
//  CGFloat+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 12..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

extension Float {
    public static func pixel(_ value: CGFloat = 1.0) -> CGFloat {
        return value/UIScreen.main.scale
    }
}

extension CGFloat {
    public static func pixel(_ value: CGFloat = 1.0) -> CGFloat {
        return value/UIScreen.main.scale
    }
}
