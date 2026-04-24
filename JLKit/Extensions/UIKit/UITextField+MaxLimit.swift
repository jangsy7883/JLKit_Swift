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
        guard let text else { return }

        if let markedRange = markedTextRange, !markedRange.isEmpty {
            // 조합 중인 글자를 제외한 확정 텍스트가 한도에 도달하면 잘라낸다.
            // (한글 IME: 확정 글자 수가 maxLength면 새 글자 조합을 막음)
            let markedText = self.text(in: markedRange) ?? ""
            let committedCount = text.count - markedText.count
            guard committedCount >= maxLength else { return }
        } else {
            guard text.count > maxLength else { return }
        }

        let selection = selectedTextRange
        self.text = String(text.prefix(maxLength))
        selectedTextRange = selection
    }
}
#endif
