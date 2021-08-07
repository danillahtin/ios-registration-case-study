//
//  IntegrationTests.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest
import UIKit
import Core
import Composition

final class Weak<Object: AnyObject> {
    weak var object: Object?

    init(_ object: Object? = nil) {
        self.object = object
    }
}

struct LoadingViewModel {
    let isLoading: Bool
}

protocol LoadingView {
    func display(viewModel: LoadingViewModel)
}

struct ButtonViewModel {
    let title: String?
    let isEnabled: Bool
}

protocol ButtonView {
    func display(viewModel: ButtonViewModel)
}

struct TitleViewModel {
    let title: String
}

protocol TitleView {
    func display(viewModel: TitleViewModel)
}

struct RegistrationViewModel {
    let cancelTitle: String
    let nextTitle: String
    let doneTitle: String
}

protocol RegistrationView {
    func display(viewModel: RegistrationViewModel)
}

extension Weak: LoadingView where Object: LoadingView {
    func display(viewModel: LoadingViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension Weak: ButtonView where Object: ButtonView {
    func display(viewModel: ButtonViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension Weak: TitleView where Object: TitleView {
    func display(viewModel: TitleViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension Weak: RegistrationView where Object: RegistrationView {
    func display(viewModel: RegistrationViewModel) {
        object?.display(viewModel: viewModel)
    }
}

final class RegistrationViewPresenter {
    private let loadingView: LoadingView
    private let buttonView: ButtonView
    private let titleView: TitleView
    private let registrationView: RegistrationView

    var buttonTitle: String { "Register" }

    init(
        loadingView: LoadingView,
        buttonView: ButtonView,
        titleView: TitleView,
        registrationView: RegistrationView
    ) {
        self.loadingView = loadingView
        self.buttonView = buttonView
        self.titleView = titleView
        self.registrationView = registrationView
    }

    func didLoadView() {
        loadingView.display(viewModel: .init(isLoading: false))
        titleView.display(viewModel: .init(title: "Registration"))
        registrationView.display(viewModel: .init(cancelTitle: "Cancel", nextTitle: "Next", doneTitle: "Done"))
    }

    func didUpdate(username: String?, password: String?) {
        let isUsernameEmpty = username?.isEmpty ?? true
        let isPasswordEmpty = password?.isEmpty ?? true

        buttonView.display(
            viewModel: .init(
                title: buttonTitle,
                isEnabled: !isUsernameEmpty && !isPasswordEmpty
            )
        )
    }

    func didStartRegistration() {
        loadingView.display(viewModel: .init(isLoading: true))
    }

    func didFinishRegistration() {
        loadingView.display(viewModel: .init(isLoading: false))
    }
}

extension RegistrationViewController: LoadingView {
    func display(viewModel: LoadingViewModel) {
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
    func display(viewModel: ButtonViewModel) {
        registerButton.setTitle(viewModel.title, for: .normal)
        registerButton.isEnabled = viewModel.isEnabled
    }
}

extension RegistrationViewController: TitleView {
    func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}

extension RegistrationViewController: RegistrationView {
    func display(viewModel: RegistrationViewModel) {
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
}

enum RegistrationViewComposer {
    private final class Adapter: RegistrationViewControllerDelegate {
        private let registrationService: RegistrationService
        private let uiScheduler: Scheduler
        private let serviceScheduler: Scheduler
        private let onRegister: () -> ()
        private let onError: (Error) -> ()

        var presenter: RegistrationViewPresenter?
        var request: RegistrationRequest = .init(username: nil, password: nil)

        init(
            registrationService: RegistrationService,
            uiScheduler: Scheduler,
            serviceScheduler: Scheduler,
            onRegister: @escaping () -> (),
            onError: @escaping (Error) -> ()
        ) {
            self.registrationService = registrationService
            self.uiScheduler = uiScheduler
            self.serviceScheduler = serviceScheduler
            self.onRegister = onRegister
            self.onError = onError
        }

        func onViewDidLoad() {
            presenter?.didLoadView()
        }

        func didUpdate(username: String?, password: String?) {
            presenter?.didUpdate(username: username, password: password)
            request = RegistrationRequest(username: username, password: password)
        }

        func onRegisterButtonTapped() {
            presenter?.didStartRegistration()

            serviceScheduler.schedule { [weak self, request] in
                switch self?.registrationService.register(with: request) {
                case .success:
                    self?.onRegister()
                case .failure(let error):
                    self?.onError(error)
                case .none:
                    break
                }

                self?.uiScheduler.schedule {
                    self?.presenter?.didFinishRegistration()
                }
            }
        }
    }

    static func composed(
        textFieldFactory: @escaping RegistrationViewController.TextFieldFactory = UITextField.init,
        tapGestureRecognizerFactory: @escaping RegistrationViewController.TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        registrationService: RegistrationService,
        uiScheduler: Scheduler = DispatchQueue.main,
        serviceScheduler: Scheduler,
        onRegister: @escaping RegistrationViewController.OnRegisterBlock,
        onError: @escaping RegistrationViewController.OnErrorBlock
    ) -> RegistrationViewController {
        let adapter = Adapter(
            registrationService: registrationService,
            uiScheduler: uiScheduler,
            serviceScheduler: serviceScheduler,
            onRegister: onRegister,
            onError: onError
        )

        let vc = RegistrationViewController(
            textFieldFactory: textFieldFactory,
            tapGestureRecognizerFactory: tapGestureRecognizerFactory,
            delegate: adapter
        )

        adapter.presenter = RegistrationViewPresenter(
            loadingView: Weak(vc),
            buttonView: Weak(vc),
            titleView: Weak(vc),
            registrationView: Weak(vc)
        )

        return vc
    }
}

protocol RegistrationViewControllerDelegate {
    func onViewDidLoad()
    func onRegisterButtonTapped()
    func didUpdate(username: String?, password: String?)
}

final class RegistrationViewController: UIViewController {
    typealias TextFieldFactory = () -> UITextField
    typealias TapGestureRecognizerFactory = (_ target: Any?, _ action: Selector?) -> UITapGestureRecognizer
    typealias OnRegisterBlock = () -> ()
    typealias OnErrorBlock = (Error) -> ()

    weak var usernameTextField: UITextField!
    weak var passwordTextField: UITextField!
    weak var registerButton: UIButton!
    weak var registerActivityIndicator: UIActivityIndicatorView!

    private let textFieldFactory: TextFieldFactory
    private let tapGestureRecognizerFactory: TapGestureRecognizerFactory
    private let delegate: RegistrationViewControllerDelegate?

    init(
        textFieldFactory: @escaping TextFieldFactory = UITextField.init,
        tapGestureRecognizerFactory: @escaping TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        delegate: RegistrationViewControllerDelegate
    ) {
        self.textFieldFactory = textFieldFactory
        self.tapGestureRecognizerFactory = tapGestureRecognizerFactory
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()

        let usernameTextField = makeUsernameTextField()
        let passwordTextField = makePasswordTextField()
        let registerButton = makeRegisterButton()
        let registerActivityIndicator = makeRegisterActivityIndicator()
        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelButtonTapped))

        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(registerActivityIndicator)
        view.addGestureRecognizer(cancelInputTapRecognizer)

        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField
        self.registerButton = registerButton
        self.registerActivityIndicator = registerActivityIndicator
        self.view = view
    }

    override func viewDidLoad() {
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

    private func makeToolbar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        notifyTextFieldUpdated()
    }

    private func notifyTextFieldUpdated() {
        delegate?.didUpdate(username: usernameTextField.text, password: passwordTextField.text)
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

    @objc
    private func onRegisterButtonTapped() {
        delegate?.onRegisterButtonTapped()
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

    var onRegisterCallCount: Int = 0

    func onRegister() {
        onRegisterCallCount += 1
    }

    var retrievedErrors: [NSError] = []

    func onError(_ error: Error) {
        retrievedErrors.append(error as NSError)
    }
}
