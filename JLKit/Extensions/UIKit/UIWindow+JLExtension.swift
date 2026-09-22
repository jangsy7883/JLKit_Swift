//
//  UIWindow+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2026/09/22.
//  Copyright © 2026 Woody. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UIWindow {
    /// 익스텐션 타깃에서도 컴파일되도록 `UIApplication.shared`를 직접 참조하지 않는다.
    private class var sharedApplication: UIApplication? {
        let selector = NSSelectorFromString("sharedApplication")
        return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }

    private class var windowScenes: [UIWindowScene] {
        sharedApplication?.connectedScenes.compactMap { $0 as? UIWindowScene } ?? []
    }

    /// 씬 델리게이트가 소유한 앱 기본 window.
    ///
    /// key window는 스낵바·광고·팝업처럼 코드로 띄운 오버레이 window가 터치 한 번으로 가져갈 수 있어서,
    /// 그 기준으로 present 하면 오버레이가 내려갈 때 띄운 화면도 함께 사라진다. 델리게이트 window는
    /// 앱이 직접 만든 것 하나뿐이므로 오버레이가 구조적으로 배제된다.
    /// 씬 델리게이트가 window를 소유하지 않는 앱(씬 매니페스트 없음)은 nil.
    public class var app: UIWindow? {
        let scene = windowScenes.first { $0.activationState == .foregroundActive } ?? windowScenes.first
        return (scene?.delegate as? UIWindowSceneDelegate)?.window ?? nil
    }

    /// 현재 key window. 오버레이가 key를 가져갈 수 있으므로 present 기준으로는 `app`을 쓰고, 이건 폴백 전용이다.
    /// (`UIWindow.key` 류는 다른 라이브러리도 흔히 정의하므로 모듈 내부에만 두고 public으로 내보내지 않는다)
    class var keyFallback: UIWindow? {
        windowScenes.flatMap { $0.windows }.last { $0.isKeyWindow }
    }
}
#endif
