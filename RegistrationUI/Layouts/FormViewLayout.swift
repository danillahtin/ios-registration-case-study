//
//  FormViewLayout.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 10.08.2021.
//

import UIKit

public final class FormViewLayout: Layout {
    private let container: UIView
    private let form: UIView

    public init(
        container: UIView,
        form: UIView
    ) {
        self.container = container
        self.form = form
    }

    public func apply() {
        form.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(form)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: form.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: form.rightAnchor),
            container.safeAreaLayoutGuide.topAnchor.constraint(equalTo: form.topAnchor, constant: -16),
        ])
    }
}
