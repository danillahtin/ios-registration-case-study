//
//  RegistrationViewLayout.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 10.08.2021.
//

import UIKit

public func RegistrationViewLayout(
    container: UIView,
    form: UIView,
    button: UIView,
    error: UIView
) -> Layout {
    LayoutComposite(components: [
        FormViewLayout(container: container, form: form),
        BottomButtonLayout(container: container, button: button),
        ErrorViewLayout(container: container, error: error),
    ])
}
