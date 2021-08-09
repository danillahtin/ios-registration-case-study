//
//  UsernamePasswordFormViewControllerTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 09.08.2021.
//

import XCTest
import XCTestHelpers
import XCTestHelpersiOS
import RegistrationPresentation
import RegistrationUI

final class UsernamePasswordFormViewControllerTests: XCTestCase {
    func test_loadView_displaysEmptyUsername() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.username, "")
    }

    func test_loadView_displaysEmptyPassword() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.password, "")
    }

    func test_loadView_displaysCorrectUsernameReturnButton() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.usernameTextField.returnKeyType, .next)
    }

    func test_displayRegistrationViewModel_displaysCorrectUsernameFirstButtonTitle() {
        let (sut, _) = makeSut()

        sut.display(viewModel: .make(cancelTitle: "some title"))
        XCTAssertEqual(sut.usernameTextField.toolbarItems?.first?.title, "some title")

        sut.display(viewModel: .make(cancelTitle: "another title"))
        XCTAssertEqual(sut.usernameTextField.toolbarItems?.first?.title, "another title")
    }

    func test_displayRegistrationViewModel_displaysCorrectUsernameLastButtonTitle() {
        let (sut, _) = makeSut()

        sut.display(viewModel: .make(nextTitle: "some title"))
        XCTAssertEqual(sut.usernameTextField.toolbarItems?.last?.title, "some title")

        sut.display(viewModel: .make(nextTitle: "another title"))
        XCTAssertEqual(sut.usernameTextField.toolbarItems?.last?.title, "another title")
    }

    func test_loadView_displaysCorrectUsernamePlaceholder() {
        let (sut, _) = makeSut()

        sut.display(viewModel: .make(usernamePlaceholder: "some placeholder"))
        XCTAssertEqual(sut.usernameTextField.placeholder, "some placeholder")

        sut.display(viewModel: .make(usernamePlaceholder: "another placeholder"))
        XCTAssertEqual(sut.usernameTextField.placeholder, "another placeholder")
    }

    func test_loadView_displaysCorrectPasswordReturnButton() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.passwordTextField.returnKeyType, .done)
    }

    func test_displayRegistrationViewModel_displaysCorrectPasswordFirstButtonTitle() {
        let (sut, _) = makeSut()

        sut.display(viewModel: .make(cancelTitle: "some title"))
        XCTAssertEqual(sut.passwordTextField.toolbarItems?.first?.title, "some title")

        sut.display(viewModel: .make(cancelTitle: "another title"))
        XCTAssertEqual(sut.passwordTextField.toolbarItems?.first?.title, "another title")
    }

    func test_displayRegistrationViewModel_displaysCorrectPasswordLastButtonTitle() {
        let (sut, _) = makeSut()

        sut.display(viewModel: .make(doneTitle: "some title"))
        XCTAssertEqual(sut.passwordTextField.toolbarItems?.last?.title, "some title")

        sut.display(viewModel: .make(doneTitle: "another title"))
        XCTAssertEqual(sut.passwordTextField.toolbarItems?.last?.title, "another title")
    }

    func test_displayRegistrationViewModel_displaysCorrectPasswordPlaceholder() {
        let (sut, _) = makeSut()

        sut.display(viewModel: .make(passwordPlaceholder: "some placeholder"))
        XCTAssertEqual(sut.passwordTextField.placeholder, "some placeholder")

        sut.display(viewModel: .make(passwordPlaceholder: "another placeholder"))
        XCTAssertEqual(sut.passwordTextField.placeholder, "another placeholder")
    }

    func test_passwordInput_isSecure() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.isPasswordInputSecure, true)
    }

    func test_givenUsernameIsActive_whenReturnButtonTapped_thenUsernameIsNotActiveInput() {
        let (sut, _) = makeSut()

        sut.simulateUsernameIsActiveInput()
        XCTAssertEqual(sut.isUsernameActiveInput, true)

        sut.simulateUsernameReturnButtonTapped()
        XCTAssertEqual(sut.isUsernameActiveInput, false)
    }

    func test_givenUsernameIsActive_whenToolbarCancelButtonTapped_thenUsernameIsNotActiveInput() {
        let (sut, _) = makeSut()

        sut.simulateUsernameIsActiveInput()
        XCTAssertEqual(sut.isUsernameActiveInput, true)

        sut.simulateUsernameToolbarCancelButtonTapped()
        XCTAssertEqual(sut.isUsernameActiveInput, false)
    }

    func test_givenUsernameIsActive_whenToolbarNextButtonTapped_thenUsernameIsNotActiveInput() {
        let (sut, _) = makeSut()

        sut.simulateUsernameIsActiveInput()
        XCTAssertEqual(sut.isUsernameActiveInput, true)

        sut.simulateUsernameToolbarNextButtonTapped()
        XCTAssertEqual(sut.isUsernameActiveInput, false)
    }

    func test_givenUsernameIsActive_whenToolbarNextButtonTapped_thenPasswordIsActiveInput() {
        let (sut, _) = makeSut()

        sut.simulateUsernameIsActiveInput()
        sut.simulateUsernameToolbarNextButtonTapped()

        XCTAssertEqual(sut.isPasswordActiveInput, true)
    }

    func test_givenPasswordIsActive_whenToolbarCancelButtonTapped_thenPasswordIsNotActiveInput() {
        let (sut, _) = makeSut()

        sut.simulatePasswordIsActiveInput()
        XCTAssertEqual(sut.isPasswordActiveInput, true)

        sut.simulatePasswordToolbarCancelButtonTapped()
        XCTAssertEqual(sut.isPasswordActiveInput, false)
    }

    func test_givenPasswordIsActive_whenToolbarDoneButtonTapped_thenPasswordIsNotActiveInput() {
        let (sut, _) = makeSut()

        sut.simulatePasswordIsActiveInput()
        XCTAssertEqual(sut.isPasswordActiveInput, true)

        sut.simulatePasswordToolbarDoneButtonTapped()
        XCTAssertEqual(sut.isPasswordActiveInput, false)
    }

    func test_displayButtonViewModel_updatesPasswordDoneButtonIsEnabled() {
        let (sut, _) = makeSut()

        sut.display(viewModel: .make(isEnabled: false))
        XCTAssertEqual(sut.isPasswordDoneButtonEnabled, false)

        sut.display(viewModel: .make(isEnabled: true))
        XCTAssertEqual(sut.isPasswordDoneButtonEnabled, true)
    }

    func test_doneButtonTapped_notifiesDelegate() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.doneButtonTappedCount, 0)
        sut.simulatePasswordToolbarDoneButtonTapped()

        XCTAssertEqual(services.doneButtonTappedCount, 1)
    }

    // MARK: - Helpers
    private func makeSut(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: UsernamePasswordFormViewController, services: Services) {
        let services = Services()
        let sut = UsernamePasswordFormViewController.make(
            textFieldFactory: TextFieldMock.init,
            delegate: services
        )

        sut.loadViewIfNeeded()
        sut.display(viewModel: RegistrationViewModel.make())

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(services, file: file, line: line)

        return (sut, services)
    }
}

private extension UsernamePasswordFormViewController {
    var username: String? {
        usernameTextField.text
    }

    var password: String? {
        passwordTextField.text
    }

    var isPasswordInputSecure: Bool {
        passwordTextField.isSecureTextEntry
    }

    var isUsernameActiveInput: Bool {
        usernameTextField.isFirstResponder
    }

    var isPasswordActiveInput: Bool {
        passwordTextField.isFirstResponder
    }

    var usernameTextFieldCancelButton: UIBarButtonItem! {
        usernameTextField.toolbarItems?.first
    }

    var usernameTextFieldNextButton: UIBarButtonItem! {
        usernameTextField.toolbarItems?.last
    }

    var passwordTextFieldCancelButton: UIBarButtonItem! {
        passwordTextField.toolbarItems?.first
    }

    var passwordTextFieldDoneButton: UIBarButtonItem! {
        passwordTextField.toolbarItems?.last
    }

    var isPasswordDoneButtonEnabled: Bool {
        passwordDoneButton?.isEnabled ?? false
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

    func simulatePasswordIsActiveInput() {
        passwordTextField.becomeFirstResponder()
    }

    func simulatePasswordToolbarCancelButtonTapped() {
        passwordTextFieldCancelButton.simulateTap()
    }

    func simulatePasswordToolbarDoneButtonTapped() {
        passwordTextFieldDoneButton.simulateTap()
    }
}

private final class Services: UsernamePasswordFormViewControllerDelegate {
    enum Message: Equatable {
        case onDoneButtonTapped
        case didUpdate(username: String?, password: String?)
    }

    private var messages: [Message] = []

    var doneButtonTappedCount: Int {
        messages.filter({ $0 == .onDoneButtonTapped }).count
    }

    func onDoneButtonTapped() {
        messages.append(.onDoneButtonTapped)
    }

    func didUpdate(username: String?, password: String?) {
        messages.append(.didUpdate(username: username, password: password))
    }
}

extension RegistrationViewModel {
    static func make(
        cancelTitle: String = "any",
        nextTitle: String = "any",
        doneTitle: String = "any",
        usernamePlaceholder: String = "any",
        passwordPlaceholder: String = "any"
    ) -> RegistrationViewModel {
        RegistrationViewModel(
            cancelTitle: cancelTitle,
            nextTitle: nextTitle,
            doneTitle: doneTitle,
            usernamePlaceholder: usernamePlaceholder,
            passwordPlaceholder: passwordPlaceholder
        )
    }
}
