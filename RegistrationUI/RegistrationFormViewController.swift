//
//  RegistrationFormViewController.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 09.08.2021.
//

import UIKit
import RegistrationPresentation

public protocol RegistrationFormViewControllerDelegate {
    func onRegisterButtonTapped()
    func didUpdate(username: String?, password: String?)
}

public final class RegistrationFormViewController: UIViewController {
    public typealias TextFieldFactory = () -> UITextField

    public private(set) weak var usernameTextField: UITextField!
    public private(set) weak var passwordTextField: UITextField!
    public private(set) var passwordDoneButton: UIBarButtonItem?

    private var textFieldFactory: TextFieldFactory!
    private var delegate: RegistrationFormViewControllerDelegate!

    public static func make(
        textFieldFactory: @escaping TextFieldFactory = UITextField.init,
        delegate: RegistrationFormViewControllerDelegate
    ) -> RegistrationFormViewController {
        let vc = RegistrationFormViewController()

        vc.textFieldFactory = textFieldFactory
        vc.delegate = delegate

        return vc
    }

    public override func loadView() {
        let usernameTextField = makeUsernameTextField()
        let passwordTextField = makePasswordTextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField

        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            passwordTextField,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.arrangedSubviews.first?.heightAnchor.constraint(equalToConstant: 60).isActive = true

        let view = UIView()
        view.addSubview(stackView)
        stackView.alignInsideSuperview()

        self.view = view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

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

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        notifyTextFieldUpdated()
    }

    private func notifyTextFieldUpdated() {
        delegate.didUpdate(
            username: usernameTextField.text,
            password: passwordTextField.text
        )
    }

    @objc
    func endEditing() {
        onCancelButtonTapped()
    }
}

extension RegistrationFormViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}

extension RegistrationFormViewController: ButtonView {
    public func display(viewModel: ButtonViewModel) {
        passwordDoneButton?.isEnabled = viewModel.isEnabled
    }
}

extension RegistrationFormViewController: RegistrationView {
    public func display(viewModel: RegistrationViewModel) {
        usernameTextField.placeholder = viewModel.usernamePlaceholder
        usernameTextField.inputAccessoryView = makeToolbar(items: [
            UIBarButtonItem(title: viewModel.cancelTitle, style: .plain, target: self, action: #selector(onCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: viewModel.nextTitle, style: .plain, target: self, action: #selector(onUsernameNextButtonTapped)),
        ])

        passwordDoneButton = UIBarButtonItem(title: viewModel.doneTitle, style: .plain, target: self, action: #selector(onPasswordDoneButtonTapped))

        passwordTextField.placeholder = viewModel.passwordPlaceholder
        passwordTextField.inputAccessoryView = makeToolbar(items: [
            UIBarButtonItem(title: viewModel.cancelTitle, style: .plain, target: self, action: #selector(onCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            passwordDoneButton!,
        ])
    }

    private func makeToolbar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 100))
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
        delegate.onRegisterButtonTapped()
    }
}
