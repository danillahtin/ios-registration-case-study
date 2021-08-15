//
//  RegistrationUIKitViewComposerTests.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest
import XCTestHelpers
import XCTestHelpersiOS
import RegistrationCore
import RegistrationPresentation
import RegistrationUI
import RegistrationComposition

final class RegistrationUIKitViewComposerTests: XCTestCase {
    func test_loadView_setsCorrectTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.title, "REGISTRATION_VIEW_TITLE_LOCALIZED")
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

        XCTAssertEqual(
            sut.registerButtonTitle,
            "REGISTRATION_REGISTER_BUTTON_TITLE_LOCALIZED"
        )
    }

    func test_loadView_displaysCorrectUsernameReturnButton() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.usernameTextField.returnKeyType, .next)
    }

    func test_loadView_displaysCorrectUsernameFirstButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(
            sut.usernameTextField.toolbarItems?.first?.title,
            "REGISTRATION_CANCEL_TITLE_LOCALIZED"
        )
    }

    func test_loadView_displaysCorrectUsernameLastButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(
            sut.usernameTextField.toolbarItems?.last?.title,
            "REGISTRATION_NEXT_TITLE_LOCALIZED"
        )
    }

    func test_loadView_displaysCorrectUsernamePlaceholder() {
        let (sut, _) = makeSut()

        XCTAssertEqual(
            sut.usernameTextField.placeholder,
            "REGISTRATION_USERNAME_PLACEHOLDER_LOCALIZED"
        )
    }

    func test_loadView_displaysCorrectPasswordReturnButton() {
        let (sut, _) = makeSut()

        XCTAssertEqual(sut.passwordTextField.returnKeyType, .done)
    }

    func test_loadView_displaysCorrectPasswordFirstButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(
            sut.passwordTextField.toolbarItems?.first?.title,
            "REGISTRATION_CANCEL_TITLE_LOCALIZED"
        )
    }

    func test_loadView_displaysCorrectPasswordLastButtonTitle() {
        let (sut, _) = makeSut()

        XCTAssertEqual(
            sut.passwordTextField.toolbarItems?.last?.title,
            "REGISTRATION_DONE_TITLE_LOCALIZED"
        )
    }

    func test_loadView_displaysCorrectPasswordPlaceholder() {
        let (sut, _) = makeSut()

        XCTAssertEqual(
            sut.passwordTextField.placeholder,
            "REGISTRATION_PASSWORD_PLACEHOLDER_LOCALIZED"
        )
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

    func test_whenUsernameOrPasswordUpdated_thenDoneButtonEnabledStateIsUpdated() {
        let (sut, _) = makeSut()

        sut.simulateUsernameInput("any")
        sut.simulatePasswordInput("")
        XCTAssertEqual(sut.isPasswordDoneButtonEnabled, false)

        sut.simulatePasswordInput("any")
        XCTAssertEqual(sut.isPasswordDoneButtonEnabled, true)

        sut.simulateUsernameInput("")
        XCTAssertEqual(sut.isPasswordDoneButtonEnabled, false)

        sut.simulateUsernameInput("any")
        XCTAssertEqual(sut.isPasswordDoneButtonEnabled, true)
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

    func test_givenSutIsNotAttachedToWindow_thenErrorViewUpdatedWithoutAnimation() {
        let (sut, services) = makeSut(shouldPreformAnimationsImmediately: false)

        XCTAssertEqual(sut.isErrorViewHidden, true)

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        services.performUIWorks()

        XCTAssertEqual(sut.isErrorViewHidden, false)
    }

    func test_givenSutIsAttachedToWindow_thenErrorViewUpdatedWithAnimation() {
        let (sut, services) = makeSut(shouldPreformAnimationsImmediately: false)

        let window = UIWindow(frame: .init(x: 0, y: 0, width: 375, height: 668))
        window.rootViewController = sut
        window.makeKeyAndVisible()
        RunLoop.current.run(until: Date())

        sut.simulateRegistration()
        services.completeRegistration(with: .failure(makeError()))
        services.performUIWorks()
        XCTAssertEqual(sut.isErrorViewHidden, true)

        services.performAnimations()
        XCTAssertEqual(sut.isErrorViewHidden, false)
    }

    // MARK: - Helpers
    private func makeSut(
        shouldPreformAnimationsImmediately: Bool = true,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RegistrationViewController, services: Services) {
        let services = Services(shouldPreformAnimationsImmediately: shouldPreformAnimationsImmediately)
        let sut = RegistrationUIKitViewComposer.composed(
            textFieldFactory: TextFieldMock.init,
            tapGestureRecognizerFactory: TapGestureRecognizerMock.init,
            registrationService: services,
            localizationProvider: services,
            uiScheduler: services.uiScheduler,
            deferredUiScheduler: NeverScheduler(),
            serviceScheduler: services.servicesScheduler,
            animator: services,
            onRegister: services.onRegister
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
    private func findController<ViewController>() -> ViewController? {
        children.compactMap({ $0 as? ViewController }).first!
    }

    private var formViewController: UsernamePasswordFormViewController! {
        findController()
    }

    private var errorViewController: ErrorViewController! {
        findController()
    }

    private var buttonViewController: ButtonViewController {
        children.compactMap({ $0 as? ButtonViewController }).first!
    }

    var registerButton: UIButton! {
        buttonViewController.button
    }

    var registerActivityIndicator: UIActivityIndicatorView! {
        buttonViewController.activityIndicator
    }

    var usernameTextField: UITextField {
        formViewController.usernameTextField
    }

    var passwordTextField: UITextField {
        formViewController.passwordTextField
    }

    var passwordDoneButton: UIBarButtonItem? {
        formViewController.passwordDoneButton
    }

    var errorView: UIButton {
        errorViewController.errorView
    }

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

private final class Services: RegistrationService, LocalizationProvider, Animator {
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

    init(shouldPreformAnimationsImmediately: Bool) {
        self.shouldPreformAnimationsImmediately = shouldPreformAnimationsImmediately
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

    func string(for key: String) -> String {
        key + "_LOCALIZED"
    }

    let shouldPreformAnimationsImmediately: Bool
    private typealias VoidBlock = () -> ()
    private var animateMessages: [(animations: VoidBlock, completion: VoidBlock?)] = []

    func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        guard shouldPreformAnimationsImmediately else {
            return animateMessages.append((animations, completion))
        }

        animations()
        completion?()
    }

    func performAnimations() {
        animateMessages.forEach {
            $0.animations()
            $0.completion?()
        }
    }
}

private struct NeverScheduler: DeferredScheduler {
    private struct Task: Cancellable {
        func cancel() {}
    }

    func schedule(after: TimeInterval, _ work: @escaping () -> ()) -> Cancellable {
        Task()
    }
}
