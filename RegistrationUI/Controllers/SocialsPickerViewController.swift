//
//  SocialsPickerViewController.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 15.08.2021.
//

import UIKit

public final class SocialsPickerViewController: UIViewController {
    public private(set) var apple: UIButton = .init()

    public var didTapAppleButton: () -> () = {}

    public override func loadView() {
        apple.addTarget(self, action: #selector(onAppleButtonTapped), for: .touchUpInside)

        view = UIView()
    }

    @objc
    private func onAppleButtonTapped() {
        didTapAppleButton()
    }
}
