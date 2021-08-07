//
//  TapGestureRecognizerMock.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import UIKit

final class TapGestureRecognizerMock: UITapGestureRecognizer {
    private let target: NSObject?
    private let action: Selector?

    override init(target: Any?, action: Selector?) {
        self.target = target as? NSObject
        self.action = action

        super.init(target: target, action: action)
    }

    func simulateTap() {
        guard let action = action else { return }

        target?.perform(action)
    }
}
