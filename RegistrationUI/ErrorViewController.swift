//
//  ErrorViewController.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 09.08.2021.
//

import UIKit
import RegistrationPresentation

public final class ErrorViewController: UIViewController {
    public weak var errorView: UIButton! { view as? UIButton }
    private var animator: Animator!

    public static func make(animator: Animator) -> ErrorViewController {
        let vc = ErrorViewController()
        vc.animator = animator

        return vc
    }

    public override func loadView() {
        let errorView = UIButton()
        errorView.contentEdgeInsets = .init(top: 24, left: 16, bottom: 24, right: 16)
        errorView.setTitleColor(.white, for: .normal)
        errorView.backgroundColor = .systemPink
        errorView.titleLabel?.numberOfLines = 0
        errorView.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        errorView.titleLabel?.textAlignment = .center
        errorView.addTarget(self, action: #selector(onErrorViewTapped), for: .touchUpInside)

        view = errorView
    }

    @objc
    private func onErrorViewTapped() {
        hideErrorView()
    }

    private func hideErrorView() {
        animator.animate { [weak self] in
            self?.errorView.alpha = 0
        }
    }

    private func showErrorView(message: String) {
        errorView.setTitle(message, for: .normal)
        animator.animate { [weak self] in
            self?.errorView.alpha = 1
        }
    }
}

extension ErrorViewController: ErrorView {
    public func display(viewModel: ErrorViewModel) {
        if let message = viewModel.message {
            showErrorView(message: message)
        } else {
            hideErrorView()
        }
    }
}
