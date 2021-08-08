//
//  RegistrationViewController.swift
//  UI
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit
import Presentation

public protocol RegistrationViewControllerDelegate {
    func onViewDidLoad()
    func onRegisterButtonTapped()
    func didUpdate(username: String?, password: String?)
}

public final class RegistrationViewController: UIViewController {
    public typealias TextFieldFactory = () -> UITextField
    public typealias TapGestureRecognizerFactory = (_ target: Any?, _ action: Selector?) -> UITapGestureRecognizer

    public private(set) weak var usernameTextField: UITextField!
    public private(set) weak var passwordTextField: UITextField!
    public private(set) weak var registerButton: UIButton!
    public private(set) weak var registerActivityIndicator: UIActivityIndicatorView!
    public private(set) weak var errorView: UIButton!

    private let textFieldFactory: TextFieldFactory
    private let tapGestureRecognizerFactory: TapGestureRecognizerFactory
    private let delegate: RegistrationViewControllerDelegate?
    private let animationScheduler: Scheduler

    public init(
        textFieldFactory: @escaping TextFieldFactory = UITextField.init,
        tapGestureRecognizerFactory: @escaping TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        animationScheduler: Scheduler,
        delegate: RegistrationViewControllerDelegate
    ) {
        self.textFieldFactory = textFieldFactory
        self.tapGestureRecognizerFactory = tapGestureRecognizerFactory
        self.delegate = delegate
        self.animationScheduler = animationScheduler

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        let view = UIView()

        let usernameTextField = makeUsernameTextField()
        let passwordTextField = makePasswordTextField()
        let registerButton = makeRegisterButton()
        let registerActivityIndicator = makeRegisterActivityIndicator()
        let errorView = makeErrorView()
        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelButtonTapped))

        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(registerActivityIndicator)
        view.addSubview(errorView)
        view.addGestureRecognizer(cancelInputTapRecognizer)

        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField
        self.registerButton = registerButton
        self.registerActivityIndicator = registerActivityIndicator
        self.errorView = errorView
        self.view = view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        delegate?.onViewDidLoad()
        notifyTextFieldUpdated()
    }

    private func makeUsernameTextField() -> UITextField {
        let textField = textFieldFactory()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = .next

        return textField
    }

    private func makePasswordTextField() -> UITextField {
        let textField = textFieldFactory()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done

        return textField
    }

    private func makeRegisterButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)

        return button
    }

    private func makeRegisterActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true

        return activityIndicator
    }

    private func makeErrorView() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(onErrorViewTapped), for: .touchUpInside)

        return button
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        notifyTextFieldUpdated()
    }

    private func notifyTextFieldUpdated() {
        delegate?.didUpdate(username: usernameTextField.text, password: passwordTextField.text)
    }

    @objc
    private func onRegisterButtonTapped() {
        delegate?.onRegisterButtonTapped()
    }

    @objc
    private func onErrorViewTapped() {
        hideErrorView()
    }

    private func hideErrorView() {
        animationScheduler.schedule { [weak self] in
            self?.errorView.alpha = 0
        }
    }

    private func showErrorView(message: String) {
        animationScheduler.schedule { [weak self] in
            self?.errorView.alpha = 1
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}

extension RegistrationViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            registerActivityIndicator.startAnimating()
            registerButton.isHidden = true
        } else {
            registerActivityIndicator.stopAnimating()
            registerButton.isHidden = false
        }
    }
}

extension RegistrationViewController: ButtonView {
    public func display(viewModel: ButtonViewModel) {
        registerButton.setTitle(viewModel.title, for: .normal)
        registerButton.isEnabled = viewModel.isEnabled
    }
}

extension RegistrationViewController: TitleView {
    public func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}

extension RegistrationViewController: RegistrationView {
    public func display(viewModel: RegistrationViewModel) {
        usernameTextField.inputAccessoryView = makeToolbar(items: [
            UIBarButtonItem(title: viewModel.cancelTitle, style: .plain, target: self, action: #selector(onCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: viewModel.nextTitle, style: .plain, target: self, action: #selector(onUsernameNextButtonTapped)),
        ])

        passwordTextField.inputAccessoryView = makeToolbar(items: [
            UIBarButtonItem(title: viewModel.cancelTitle, style: .plain, target: self, action: #selector(onCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: viewModel.doneTitle, style: .plain, target: self, action: #selector(onPasswordDoneButtonTapped)),
        ])
    }

    private func makeToolbar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }

    @objc
    private func onCancelButtonTapped() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc
    private func onUsernameNextButtonTapped() {
        usernameTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }

    @objc
    private func onPasswordDoneButtonTapped() {
        passwordTextField.resignFirstResponder()
        onRegisterButtonTapped()
    }
}

extension RegistrationViewController: ErrorView {
    public func display(viewModel: ErrorViewModel) {
        if let message = viewModel.message {
            showErrorView(message: message)
        } else {
            hideErrorView()
        }
    }
}
