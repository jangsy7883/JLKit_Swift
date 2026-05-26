//
//  UITextView+MaxLimit.swift
//  JLKit
//
//  Created by 장석용 on 2026/04/24.
//  Copyright © 2026 장석용. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

private var kAssociationKeyMaxLengthTextView: Int = 0
private var kAssociationKeyObserver: Int = 0

private final class MaxLengthObserver {
    weak var textView: UITextView?

    init(_ textView: UITextView) {
        self.textView = textView
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: textView
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func textDidChange() {
        textView?._checkMaxLength()
    }
}

public extension UITextView {
    @IBInspectable var maxLength: Int {
        get {
            return (objc_getAssociatedObject(self, &kAssociationKeyMaxLengthTextView) as? Int) ?? Int.max
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLengthTextView, newValue, .OBJC_ASSOCIATION_RETAIN)
            // observer를 associated object로 보관 → UITextView 해제 시 deinit에서 자동 removeObserver
            let observer = MaxLengthObserver(self)
            objc_setAssociatedObject(self, &kAssociationKeyObserver, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc fileprivate func _checkMaxLength() {
        guard let text else { return }

        if let markedRange = markedTextRange, !markedRange.isEmpty {
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
