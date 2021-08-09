//
//  ButtonViewController.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 10.08.2021.
//

import UIKit
import RegistrationPresentation

public final class ButtonViewController: UIViewController {
    public private(set) weak var button: UIButton!
    public private(set) weak var activityIndicator: UIActivityIndicatorView!

    public var onButtonTappedBlock: (() -> ())?

    public static func make() -> ButtonViewController {
        ButtonViewController()
    }

    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemIndigo

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white

        view.addSubview(button)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.leftAnchor),
            button.rightAnchor.constraint(equalTo: view.rightAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        self.button = button
        self.activityIndicator = activityIndicator
        self.view = view
    }

    @objc
    private func onButtonTapped() {
        onButtonTappedBlock?()
    }
}

extension ButtonViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
            button.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            button.isHidden = false
        }
    }
}

extension ButtonViewController: ButtonView {
    public func display(viewModel: ButtonViewModel) {
        button.setTitle(viewModel.title, for: .normal)
        button.isEnabled = viewModel.isEnabled
        view.backgroundColor = viewModel.isEnabled
            ? view.backgroundColor?.withAlphaComponent(1)
            : view.backgroundColor?.withAlphaComponent(0.4)
    }
}
