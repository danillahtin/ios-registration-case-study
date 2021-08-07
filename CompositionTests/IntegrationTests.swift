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
        usernameTextField.delegate = self
        usernameTextField.inputAccessoryView = makeToolbar(items: [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(onUsernameNextButtonTapped)),
        ])
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

    private func makeToolbar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        let isUsernameEmpty = usernameTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true

        registerButton.isEnabled = !isUsernameEmpty && !isPasswordEmpty
    }

    @objc
    func onCancelButtonTapped() {
        usernameTextField.resignFirstResponder()
    }

    @objc
    func onUsernameNextButtonTapped() {
        usernameTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
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

    func test_givenUsernameIsActive_whenReturnButtonTapped_thenUsernameIsNotActiveInput() {
        let sut = makeSut()

        sut.simulateUsernameIsActiveInput()
        XCTAssertEqual(sut.isUsernameActiveInput, true)

        sut.simulateUsernameReturnButtonTapped()
        XCTAssertEqual(sut.isUsernameActiveInput, false)
    }

    func test_givenUsernameIsActive_whenToolbarCancelButtonTapped_thenUsernameIsNotActiveInput() {
        let sut = makeSut()

        sut.simulateUsernameIsActiveInput()
        XCTAssertEqual(sut.isUsernameActiveInput, true)

        sut.simulateUsernameToolbarCancelButtonTapped()
        XCTAssertEqual(sut.isUsernameActiveInput, false)
    }

    func test_givenUsernameIsActive_whenToolbarNextButtonTapped_thenUsernameIsNotActiveInput() {
        let sut = makeSut()

        sut.simulateUsernameIsActiveInput()
        XCTAssertEqual(sut.isUsernameActiveInput, true)

        sut.simulateUsernameToolbarNextButtonTapped()
        XCTAssertEqual(sut.isUsernameActiveInput, false)
    }

    func test_givenUsernameIsActive_whenToolbarNextButtonTapped_thenPasswordIsActiveInput() {
        let sut = makeSut()

        sut.simulateUsernameIsActiveInput()
        sut.simulateUsernameToolbarNextButtonTapped()

        XCTAssertEqual(sut.isPasswordActiveInput, true)
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

    var isUsernameActiveInput: Bool {
        usernameTextField.isFirstResponder
    }

    var isPasswordActiveInput: Bool {
        passwordTextField.isFirstResponder
    }

    var usernameTextFieldCancelButton: UIBarButtonItem! {
        let toolbar = usernameTextField.inputAccessoryView as? UIToolbar
        return toolbar?.items?.first(where: { $0.title?.lowercased() == "cancel" })
    }

    var usernameTextFieldNextButton: UIBarButtonItem! {
        let toolbar = usernameTextField.inputAccessoryView as? UIToolbar
        return toolbar?.items?.first(where: { $0.title?.lowercased() == "next" })
    }

    func simulateUsernameInput(_ username: String) {
        usernameTextField.text = username
        usernameTextField.simulate(event: .editingChanged, with: usernameTextField)
    }

    func simulatePasswordInput(_ password: String) {
        passwordTextField.text = password
        passwordTextField.simulate(event: .editingChanged, with: passwordTextField)
    }

    func simulateUsernameIsActiveInput() {
        usernameTextField.becomeFirstResponder()
    }

    func simulateUsernameReturnButtonTapped() {
        _ = usernameTextField.delegate?.textFieldShouldReturn?(usernameTextField)
    }

    func simulateUsernameToolbarCancelButtonTapped() {
        usernameTextFieldCancelButton.simulateTap()
    }

    func simulateUsernameToolbarNextButtonTapped() {
        usernameTextFieldNextButton.simulateTap()
    }
}

extension UIControl {
    static var isFirstResponderAssociatedKey: Void?
    
    private var _isFirstResponder: Bool {
        get {
            objc_getAssociatedObject(self, &UIControl.isFirstResponderAssociatedKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &UIControl.isFirstResponderAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    open override var isFirstResponder: Bool {
        _isFirstResponder
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        guard canBecomeFirstResponder else { return false }

        _isFirstResponder = true

        return true
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        guard isFirstResponder else { return false }

        _isFirstResponder = false

        return true
    }

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

extension UIBarButtonItem {
    func simulateTap() {
        (target as! NSObject).perform(action!)
    }
}
