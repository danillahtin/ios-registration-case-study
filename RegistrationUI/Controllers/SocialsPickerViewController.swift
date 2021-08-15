//
//  SocialsPickerViewController.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 15.08.2021.
//

import UIKit
import AuthenticationServices

public final class SocialsPickerViewController: UIViewController {
    public private(set) var appleButton: UIButton = .init()
    public var didTapAppleButton: () -> () = {}

    public override func loadView() {
        let appleButton = UIButton(type: .system)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.setImage(UIImage(named: "apple", in: Bundle(for: Self.self), compatibleWith: nil), for: .normal)
        appleButton.addTarget(self, action: #selector(onAppleButtonTapped), for: .touchUpInside)

        self.appleButton = appleButton

        let stackView = UIStackView(arrangedSubviews: [appleButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView()
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        self.view = view
    }

    @objc
    private func onAppleButtonTapped() {
        didTapAppleButton()
    }
}
