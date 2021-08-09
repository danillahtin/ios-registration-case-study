//
//  ButtonViewModel+Helpers.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import RegistrationPresentation

extension ButtonViewModel {
    static func make(
        title: String? = nil,
        isEnabled: Bool = true
    ) -> ButtonViewModel {
        ButtonViewModel(title: title, isEnabled: isEnabled)
    }
}

