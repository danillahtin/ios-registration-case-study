//
//  ErrorViewLayout.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 10.08.2021.
//

import UIKit

public final class ErrorViewLayout: Layout {
    private let container: UIView
    private let error: UIView

    public init(
        container: UIView,
        error: UIView
    ) {
        self.container = container
        self.error = error
    }

    public func apply() {
        error.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(error)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: error.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: error.rightAnchor),
            container.safeAreaLayoutGuide.topAnchor.constraint(equalTo: error.topAnchor, constant: -40),
        ])
    }
}
