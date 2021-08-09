//
//  Helpers.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 09.08.2021.
//

import UIKit

extension UIView {
    func alignInsideSuperview() {
        guard let superview = superview else { return }

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}
