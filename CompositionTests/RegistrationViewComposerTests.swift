//
//  RegistrationViewComposerTests.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest
import Core
import UI
import Composition

final class RegistrationViewComposerTests: XCTestCase {
    func test_loadView_setsCorrectTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.title, "Registration")
    }

    func test_loadView_displaysEmptyUsername() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.username, "")
    }

    func test_loadView_displaysEmptyPassword() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.password, "")
    }

    func test_loadView_displaysRegisterButton() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.isRegisterButtonHidden, false)
    }

    func test_loadView_displaysCorrectRegisterButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.registerButtonTitle, "Register")
    }

    func test_loadView_displaysCorrectUsernameReturnButton() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.usernameTextField.returnKeyType, .next)
    }

    func test_loadView_displaysCorrectUsernameFirstButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.usernameTextField.toolbarItems?.first?.title, "Cancel")
    }

    func test_loadView_displaysCorrectUsernameLastButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.usernameTextField.toolbarItems?.last?.title, "Next")
    }

    func test_loadView_displaysCorrectPasswordReturnButton() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.passwordTextField.returnKeyType, .done)
    }

    func test_loadView_displaysCorrectPasswordFirstButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.passwordTextField.toolbarItems?.first?.title, "Cancel")
    }

    func test_loadView_displaysCorrectPasswordLastButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.passwordTextField.toolbarItems?.last?.title, "Done")
    }

    func test_loadView_hidesRegisterActivityIndicator() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.isRegisterActivityIndicatorHidden, true)
    }

    func test_loadView_hidesErrorView() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.isErrorViewHidden, true)
    }

    func test_passwordInput_isSecure() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.isPasswordInputSecure, true)
    }

    func test_givenUsernameIsEmpty_thenRegisterButtonIsDisabled() {
        let (sut, _) = makeSut()

        sut.simulateUsernameInput("")

        XCTAssertEqual(sut.isRegisterButtonEnabled, false)
    }

    func test_givenPasswordIsEmpty_thenRegisterButtonIsDisabled() {
        let (sut, _) = makeSut()

        sut.simulatePasswordInput("")

        XCTAssertEqual(sut.isRegisterButtonEnabled, false)
    }

    func test_registerButtonEnabling() {
        let (sut, _) = makeSut()

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

    func test_givenUsernameIsActive_whenViewTapped_thenUsernameIsNotActiveInput() {
        let (sut, _) = makeSut()

        sut.simulateUsernameIsActiveInput()
        sut.simulateViewTapped()

        XCTAssertEqual(sut.isUsernameActiveInput, false)
    }

    func test_givenRegisterButtonTapped_thenRegisterButtonIsHidden() {
        let (sut, _) = makeSut()

        sut.simulateRegisterButtonTapped()

        XCTAssertEqual(sut.isRegisterButtonHidden, true)
    }

    func test_givenRegisterButtonTapped_thenRegisterActivityIndicatorIsNotHidden() {
        let (sut, _) = makeSut()

        sut.simulateRegisterButtonTapped()

        XCTAssertEqual(sut.isRegisterActivityIndicatorHidden, false)
    }

    func test_givenRegisterButtonTapped_thenRegisterActivityIndicatorIsAnimating() {
        let (sut, _) = makeSut()

        sut.simulateRegisterButtonTapped()

        XCTAssertEqual(sut.registerActivityIndicator.isAnimating, true)
    }

    func test_givenRegisterButtonTapped_thenRegistrationIsRequestedWithUsernameAndPassword() {
        let (sut, services) = makeSut()

        sut.simulateRegisterButtonTapped()
        services.performServiceWorks()
        XCTAssertEqual(services.requests, [makeRequest(username: "", password: "")])

        sut.simulateUsernameInput("some username")
        sut.simulatePasswordInput("some password")
        sut.simulateRegisterButtonTapped()
        services.performServiceWorks()
        XCTAssertEqual(services.requests, [
            makeRequest(username: "", password: ""),
            makeRequest(username: "some username", password: "some password"),
        ])
    }

    func test_givenRegisterButtonTapped_thenRegistrationIsScheduled() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        XCTAssertEqual(services.requests, [])

        services.performServiceWorks()
        XCTAssertEqual(services.requests, [makeRequest()])
    }

    func test_givenPasswordIsActive_whenToolbarDoneButtonTapped_thenRegistrationIsRequestedWithUsernameAndPassword() {
        let (sut, services) = makeSut()

        sut.simulateUsernameInput("some username")
        sut.simulatePasswordInput("some password")
        sut.simulatePasswordIsActiveInput()
        sut.simulatePasswordToolbarDoneButtonTapped()
        services.performServiceWorks()

        XCTAssertEqual(services.requests, [makeRequest(username: "some username", password: "some password")])
    }

    func test_whenRegistrationCompletesWithFailure_thenRegistrationButtonIsNotHiddenIsScheduledOnUI() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        XCTAssertEqual(sut.isRegisterButtonHidden, true)

        services.performUIWorks()
        XCTAssertEqual(sut.isRegisterButtonHidden, false)
    }

    func test_whenRegistrationCompletesWithFailure_thenRegistrationActivityIndicatorIsHiddenIsScheduledOnUI() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        XCTAssertEqual(sut.isRegisterActivityIndicatorHidden, false)

        services.performUIWorks()
        XCTAssertEqual(sut.isRegisterActivityIndicatorHidden, true)
    }

    func test_whenRegistrationCompletesWithFailure_thenOnRegisterIsNotCalled() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()

        XCTAssertEqual(services.onRegisterCallCount, 0)
        services.completeRegistration(with: .failure(makeError()))

        XCTAssertEqual(services.onRegisterCallCount, 0)
    }

    func test_whenRegistrationCompletesWithFailure_thenOnErrorIsCalled() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        XCTAssertEqual(services.retrievedErrors, [])

        services.completeRegistration(with: .failure(makeError("some error")))
        XCTAssertEqual(services.retrievedErrors, [makeError("some error")])

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError("another error")))
        XCTAssertEqual(services.retrievedErrors, [
            makeError("some error"),
            makeError("another error")
        ])
    }

    func test_whenRegistrationCompletesWithFailure_thenErrorViewIsDisplayedWithCorrectMessage() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError("some error")))
        services.performUIWorks()
        XCTAssertEqual(sut.errorViewMessage, "some error")

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError("another error")))
        services.performUIWorks()
        XCTAssertEqual(sut.errorViewMessage, "another error")
    }

    func test_givenErrorViewIsDisplayed_whenUsernameIsUpdated_thenErrorViewIsHiddenIsScheduledOnUI() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        XCTAssertEqual(sut.isErrorViewHidden, true)

        services.performUIWorks()
        XCTAssertEqual(sut.isErrorViewHidden, false)

        sut.simulateUsernameInput("any")
        XCTAssertEqual(sut.isErrorViewHidden, true)
    }

    func test_givenErrorViewIsDisplayed_whenPasswordIsUpdated_thenErrorViewIsHiddenIsScheduledOnUI() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        XCTAssertEqual(sut.isErrorViewHidden, true)

        services.performUIWorks()
        XCTAssertEqual(sut.isErrorViewHidden, false)

        sut.simulatePasswordInput("any")
        XCTAssertEqual(sut.isErrorViewHidden, true)
    }

    func test_givenErrorViewIsDisplayed_whenRegisterButtonIsTapped_thenErrorViewIsHiddenIsScheduledOnUI() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        XCTAssertEqual(sut.isErrorViewHidden, true)

        services.performUIWorks()
        XCTAssertEqual(sut.isErrorViewHidden, false)

        sut.simulateRegisterButtonTapped()
        XCTAssertEqual(sut.isErrorViewHidden, true)
    }

    func test_givenErrorViewIsDisplayed_whenErrorViewTapped_thenErrorViewIsHidden() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        services.performUIWorks()
        XCTAssertEqual(sut.isErrorViewHidden, false)

        sut.simulateErrorViewTapped()
        XCTAssertEqual(sut.isErrorViewHidden, true)
    }

    func test_whenRegistrationCompletesWithSuccess_thenRegistrationButtonIsNotHiddenIsScheduledOnUI() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .success(()))
        XCTAssertEqual(sut.isRegisterButtonHidden, true)

        services.performUIWorks()
        XCTAssertEqual(sut.isRegisterButtonHidden, false)
    }

    func test_whenRegistrationCompletesWithSuccess_thenRegistrationActivityIndicatorIsHiddenIsScheduledOnUI() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        services.completeRegistration(with: .success(()))
        XCTAssertEqual(sut.isRegisterActivityIndicatorHidden, false)

        services.performUIWorks()
        XCTAssertEqual(sut.isRegisterActivityIndicatorHidden, true)
    }

    func test_whenRegistrationCompletesWithSuccess_thenOnRegisterIsCalled() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()

        XCTAssertEqual(services.onRegisterCallCount, 0)
        services.completeRegistration(with: .success(()))

        XCTAssertEqual(services.onRegisterCallCount, 1)
    }

    func test_whenRegistrationCompletesWithSuccess_thenOnErrorIsNotCalled() {
        let (sut, services) = makeSut()

        sut.simulateRegistration()
        XCTAssertEqual(services.retrievedErrors, [])

        services.completeRegistration(with: .success(()))
        XCTAssertEqual(services.retrievedErrors, [])
    }

    // MARK: - Helpers
    private func makeSut(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RegistrationViewController, services: Services) {
        let services = Services()
        let sut = RegistrationViewComposer.composed(
            textFieldFactory: TextFieldMock.init,
            tapGestureRecognizerFactory: TapGestureRecognizerMock.init,
            registrationService: services,
            uiScheduler: services.uiScheduler,
            serviceScheduler: services.servicesScheduler,
            animator: ImmediateAnimator(),
            onRegister: services.onRegister,
            onError: services.onError
        )

        sut.loadViewIfNeeded()

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(services, file: file, line: line)

        return (sut, services)
    }

    private func makeRequest(username: String? = "any", password: String? = "any") -> RegistrationRequest {
        .init(username: username, password: password)
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

    var isRegisterActivityIndicatorHidden: Bool {
        registerActivityIndicator.isHidden
    }

    var isErrorViewHidden: Bool {
        errorView.alpha == 0
    }

    var errorViewMessage: String? {
        errorView.title(for: .normal)
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

    func simulateViewTapped() {
        view.gestureRecognizers?
            .compactMap({ $0 as? TapGestureRecognizerMock })
            .forEach { $0.simulateTap() }
    }

    func simulateRegisterButtonTapped() {
        registerButton.simulateTap()
    }

    func simulateRegistration(username: String = "any", password: String = "any") {
        simulateUsernameInput(username)
        simulatePasswordInput(password)
        simulateRegisterButtonTapped()
    }

    func simulateErrorViewTapped() {
        errorView.simulateTap()
    }
}

private final class Services: RegistrationService {
    final class SchedulerSpy: Scheduler {
        private var works: [() -> ()] = []

        func schedule(_ work: @escaping () -> ()) {
            works.append(work)
        }

        func performWorks() {
            works.forEach({ $0() })
            works = []
        }
    }

    private(set) var requests: [RegistrationRequest] = []
    private var registrationResultStub: Result<Void, Error>?

    func register(with request: RegistrationRequest) -> Result<Void, Error> {
        requests.append(request)

        return registrationResultStub ?? .success(())
    }

    let servicesScheduler = SchedulerSpy()
    let uiScheduler = SchedulerSpy()

    func performServiceWorks() {
        servicesScheduler.performWorks()
    }

    func performUIWorks() {
        uiScheduler.performWorks()
    }

    func completeRegistration(with result: Result<Void, Error>) {
        registrationResultStub = result
        performServiceWorks()
    }

    private(set) var onRegisterCallCount: Int = 0

    func onRegister() {
        onRegisterCallCount += 1
    }

    private(set) var retrievedErrors: [NSError] = []

    func onError(_ error: Error) {
        retrievedErrors.append(error as NSError)
    }
}

private struct ImmediateAnimator: Animator {
    func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        animations()
        completion?()
    }
}
