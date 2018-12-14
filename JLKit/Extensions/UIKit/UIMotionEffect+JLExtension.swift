//
//  UIMotionEffect+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 26..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UIMotionEffect {
    @objc public static func twoAxesShift(strength: Float) -> UIMotionEffect {
        func motion(type: UIInterpolatingMotionEffect.EffectType) -> UIInterpolatingMotionEffect {
            let keyPath = type == .tiltAlongHorizontalAxis ? "center.x" : "center.y"
            let motion = UIInterpolatingMotionEffect(keyPath: keyPath, type: type)
            motion.minimumRelativeValue = -strength
            motion.maximumRelativeValue = strength
            return motion
        }

        let group = UIMotionEffectGroup()
        group.motionEffects = [
            motion(type: .tiltAlongHorizontalAxis),
            motion(type: .tiltAlongVerticalAxis)
        ]
        return group
    }
}
