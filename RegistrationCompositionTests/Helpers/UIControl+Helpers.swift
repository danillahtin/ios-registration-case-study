//
//  UIControl+Helpers.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import UIKit

extension UIControl {
    private func perform(for event: UIControl.Event, _ block: (NSObject, Selector) -> ()) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach { action in
                block(target as NSObject, Selector(action))
            }
        }
    }

    func simulate(event: UIControl.Event, with argument: Any!) {
        perform(for: event) {
            $0.perform($1, with: argument)
        }
    }

    func simulate(event: UIControl.Event) {
        perform(for: event) { $0.perform($1) }
    }
}

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
