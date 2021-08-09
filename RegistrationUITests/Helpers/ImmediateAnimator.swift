//
//  ImmediateAnimator.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import RegistrationUI

final class ImmediateAnimator: Animator {
    func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        animations()
        completion?()
    }
}

