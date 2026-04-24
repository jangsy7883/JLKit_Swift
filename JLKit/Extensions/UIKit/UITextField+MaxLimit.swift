//
//  UITextField+MaxLimit.swift
//  TheBaby
//
//  Created by 장석용 on 2020/07/08.
//  Copyright © 2020 장석용. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

private var kAssociationKeyMaxLength: Int = 0

public extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            return (objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int) ?? Int.max
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            removeTarget(self, action: #selector(_checkMaxLength), for: .editingChanged)
            addTarget(self, action: #selector(_checkMaxLength), for: .editingChanged)
        }
    }

    @objc private func _checkMaxLength() {
        guard let text, text.count > maxLength else { return }

        // IME 조합 중(한/중/일 입력)일 때는 truncation 스킵
        if let markedRange = markedTextRange, !markedRange.isEmpty { return }

        let selection = selectedTextRange
        self.text = String(text.prefix(maxLength))
        selectedTextRange = selection
    }
}
#endif
