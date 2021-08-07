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
        let passwordTextField = UITextField()
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
    }
}
