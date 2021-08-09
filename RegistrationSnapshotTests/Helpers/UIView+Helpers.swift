//
//  UIView+Helpers.swift
//  RegistrationSnapshotTests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import UIKit

func makeView(name: String, color: UIColor, height: CGFloat? = nil) -> UIView {
    let label = UILabel()
    label.backgroundColor = color
    label.text = name
    label.textAlignment = .center
    label.textColor = .black
    height.map({ label.heightAnchor.constraint(equalToConstant: $0).isActive = true })

    return label
}
