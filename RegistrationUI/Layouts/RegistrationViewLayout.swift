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
    socials: UIView,
    error: UIView
) -> Layout {
    LayoutComposite(components: [
        FormViewLayout(container: container, form: form),
        BottomButtonLayout(container: container, button: button),
        ErrorViewLayout(container: container, error: error),
        SocialsLayout(container: container, bottomView: button, socials: socials),
    ])
}

private final class SocialsLayout: Layout {
    private let container: UIView
    private let bottomView: UIView
    private let socials: UIView

    init(
        container: UIView,
        bottomView: UIView,
        socials: UIView
    ) {
        self.container = container
        self.bottomView = bottomView
        self.socials = socials
    }

    func apply() {
        socials.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(socials)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: socials.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: socials.rightAnchor),
            bottomView.topAnchor.constraint(equalTo: socials.bottomAnchor, constant: 16),
        ])
    }
}
