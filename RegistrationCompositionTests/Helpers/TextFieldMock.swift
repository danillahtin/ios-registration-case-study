//
//  TextFieldMock.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import UIKit

final class TextFieldMock: UITextField {
    private var _isFirstResponder: Bool = false

    override var isFirstResponder: Bool {
        _isFirstResponder
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        guard canBecomeFirstResponder else { return false }

        _isFirstResponder = true

        return true
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        guard isFirstResponder else { return false }

        _isFirstResponder = false

        return true
    }
}
