//
//  File.swift
//  UI
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit

public protocol Animator {
    func animate(_ animations: @escaping () -> (), completion: (() -> ())?)
}

extension Animator {
    func animate(_ animations: @escaping () -> ()) {
        animate(animations, completion: nil)
    }
}

public struct UIKitAnimator: Animator {
    private let duration: TimeInterval

    public static let fast: UIKitAnimator = .init(duration: 0.16)

    private init(duration: TimeInterval) {
        self.duration = duration
    }

    public func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: animations,
            completion: completion.map({ completion in { _ in completion() } })
        )
    }
}

public final class IfAttachedToWindowAnimatorDecorator: Animator {
    private let decoratee: Animator
    private let isAttachedToWindow: () -> Bool

    public init(decoratee: Animator, isAttachedToWindow: @escaping () -> Bool) {
        self.decoratee = decoratee
        self.isAttachedToWindow = isAttachedToWindow
    }

    public func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        if isAttachedToWindow() {
            return decoratee.animate(animations, completion: completion)
        }

        animations()
        completion?()
    }
}
