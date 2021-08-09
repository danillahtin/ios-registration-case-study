//
//  BottomButtonLayout.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 10.08.2021.
//

import UIKit

public final class BottomButtonLayout: Layout {
    private let container: UIView
    private let button: UIView

    public init(
        container: UIView,
        button: UIView
    ) {
        self.container = container
        self.button = button
    }

    public func apply() {
        button.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(button)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: button.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: button.rightAnchor),
            container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 44),
        ])
    }
}
