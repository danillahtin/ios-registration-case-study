//
//  ViewController.swift
//  Prototype
//
//  Created by Danil Lahtin on 06.08.2021.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var registrationActivityIndicatorIndicator: UIActivityIndicatorView!
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        usernameTextField.inputAccessoryView = makeToolbar(items: makeUsernameToolbarItems())

        passwordTextField.delegate = self
        passwordTextField.inputAccessoryView = makeToolbar(items: makePasswordToolbarItems())

        view.addGestureRecognizer(tapRecognizer)
        tapRecognizer.isEnabled = false

        registerButton.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
        display(isLoading: false)
    }

    private func makeUsernameToolbarItems() -> [UIBarButtonItem] {
        return [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(switchToPasswordInput)),
        ]
    }

    private func makePasswordToolbarItems() -> [UIBarButtonItem] {
        return [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onPasswordDoneButtonTapped)),
        ]
    }

    private func makeToolbar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func switchToPasswordInput() {
        passwordTextField.becomeFirstResponder()
    }

    @objc
    private func onPasswordDoneButtonTapped() {
        dismissKeyboard()
        onRegisterButtonTapped()
    }

    @objc
    private func onRegisterButtonTapped() {
        display(isLoading: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [self] in
            self.display(isLoading: false)
            self.showSuccessAlert()
        }
    }

    private func display(isLoading: Bool) {
        registerButton.isHidden = isLoading
        registrationActivityIndicatorIndicator.isHidden = !isLoading

        if isLoading {
            registrationActivityIndicatorIndicator.startAnimating()
        } else {
            registrationActivityIndicatorIndicator.stopAnimating()
        }
    }

    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success!", message: nil, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tapRecognizer.isEnabled = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        tapRecognizer.isEnabled = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }

        return true
    }
}
