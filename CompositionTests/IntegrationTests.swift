//
//  IntegrationTests.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest
import UIKit

final class RegistrationViewController: UIViewController {
    weak var usernameTextField: UITextField!
    weak var passwordTextField: UITextField!
    weak var registerButton: UIButton!

    override func loadView() {
        let view = UIView()

        let usernameTextField = UITextField()
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let passwordTextField = UITextField()
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.isSecureTextEntry = true
        let registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.isEnabled = false

        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)

        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField
        self.registerButton = registerButton
        self.view = view

        self.title = "Registration"
    }

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        let isUsernameEmpty = usernameTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true

        registerButton.isEnabled = !isUsernameEmpty && !isPasswordEmpty
    }
}

final class IntegrationTests: XCTestCase {
    func test_loadView_setsCorrectTitle() {
        let sut = makeSut()

        XCTAssertEqual(sut.title, "Registration")
    }

    func test_loadView_displaysEmptyUsername() {
        let sut = makeSut()

        XCTAssertEqual(sut.username, "")
    }

    func test_loadView_displaysEmptyPassword() {
        let sut = makeSut()

        XCTAssertEqual(sut.password, "")
    }

    func test_loadView_displaysRegisterButton() {
        let sut = makeSut()

        XCTAssertEqual(sut.isRegisterButtonHidden, false)
    }

    func test_loadView_displaysCorrectRegisterButtonTitle() {
        let sut = makeSut()

        XCTAssertEqual(sut.registerButtonTitle, "Register")
    }

    func test_passwordInput_isSecure() {
        let sut = makeSut()

        XCTAssertEqual(sut.isPasswordInputSecure, true)
    }

    func test_givenUsernameIsEmpty_thenRegisterButtonIsDisabled() {
        let sut = makeSut()

        sut.simulateUsernameInput("")

        XCTAssertEqual(sut.isRegisterButtonEnabled, false)
    }

    func test_givenPasswordIsEmpty_thenRegisterButtonIsDisabled() {
        let sut = makeSut()

        sut.simulatePasswordInput("")

        XCTAssertEqual(sut.isRegisterButtonEnabled, false)
    }

    func test_registerButtonEnabling() {
        let sut = makeSut()

        XCTAssertEqual(sut.isRegisterButtonEnabled, false, "Expected register button to be disabled when both fields are empty")

        sut.simulatePasswordInput("some password")
        XCTAssertEqual(sut.isRegisterButtonEnabled, false, "Expected register button to be disabled when username is empty")

        sut.simulateUsernameInput("some username")
        XCTAssertEqual(sut.isRegisterButtonEnabled, true, "Expected register button to be enabled when both fields are non empty")

        sut.simulatePasswordInput("")
        XCTAssertEqual(sut.isRegisterButtonEnabled, false, "Expected register button to be disabled when password is empty")

        sut.simulatePasswordInput("another password")
        XCTAssertEqual(sut.isRegisterButtonEnabled, true, "Expected register button to be enabled when both fields become non empty again")
    }

    // MARK: - Helpers
    private func makeSut() -> RegistrationViewController {
        let sut = RegistrationViewController()

        sut.loadViewIfNeeded()

        return sut
    }
}

private extension RegistrationViewController {
    var username: String? {
        usernameTextField.text
    }

    var password: String? {
        passwordTextField.text
    }

    var isPasswordInputSecure: Bool {
        passwordTextField.isSecureTextEntry
    }

    var isRegisterButtonHidden: Bool {
        registerButton.isHidden
    }

    var registerButtonTitle: String? {
        registerButton.title(for: .normal)
    }

    var isRegisterButtonEnabled: Bool {
        registerButton.isEnabled
    }

    func simulateUsernameInput(_ username: String) {
        usernameTextField.text = username
        usernameTextField.simulate(event: .editingChanged, with: usernameTextField)
    }

    func simulatePasswordInput(_ password: String) {
        passwordTextField.text = password
        passwordTextField.simulate(event: .editingChanged, with: passwordTextField)
    }
}

private extension UIControl {
    private func perform(for event: UIControl.Event, _ block: (NSObject, Selector) -> ()) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach { action in
                block(target as NSObject, Selector(action))
            }
        }
    }

    func simulate(event: UIControl.Event, with argument: Any!) {
        perform(for: event) {
            $0.perform($1, with: argument)
        }
    }

    func simulate(event: UIControl.Event) {
        perform(for: event) { $0.perform($1) }
    }
}
