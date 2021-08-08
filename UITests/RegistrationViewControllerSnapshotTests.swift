//
//  RegistrationViewControllerSnapshotTests.swift
//  UITests
//
//  Created by Danil Lahtin on 08.08.2021.
//

import SnapshotTesting
import XCTest
import Presentation
import UI

final class RegistrationViewControllerSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        super.tearDown()

        UIView.setAnimationsEnabled(true)
    }

    func test_initialState() {
        assertSnapshot()
    }

    func test_usernameShortFilled() {
        assertSnapshot(username: "Short name")
    }

    func test_usernameLongFilled() {
        assertSnapshot(username: "Very very very very very very very very very very long name")
    }

    func test_passwordShortFilled() {
        assertSnapshot(password: "Short password")
    }

    func test_passwordLongFilled() {
        assertSnapshot(password: "Very very very very very very very very very long password")
    }

    func test_loading() {
        assertSnapshot { $0.displayLoadingState() }
    }

    func test_errorState() {
        assertSnapshot { $0.displayErrorState(message: "Short error message") }
        assertSnapshot { $0.displayErrorState(message: "Very very very very very very very very very very very very very long error message") }
    }

    func test_registerButtonEnabledState() {
        assertSnapshot { $0.displayRegisterButton(enabled: false) }
        assertSnapshot { $0.displayRegisterButton(enabled: true) }
    }

    // MARK: - Helpers

    private func assertSnapshot(
        username: String? = nil,
        password: String? = nil,
        prepare block: (RegistrationViewController) -> () = { _ in },
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let sut = makeSut(username: username, password: password, prepare: block)

        SnapshotTesting.assertSnapshot(
            matching: sut,
            as: .image(on: .iPhoneSe),
            file: file,
            testName: testName,
            line: line
        )

        SnapshotTesting.assertSnapshot(
            matching: sut,
            as: .image(on: .iPhoneX),
            file: file,
            testName: testName,
            line: line
        )

        sut.overrideUserInterfaceStyle = .dark

        SnapshotTesting.assertSnapshot(
            matching: sut,
            as: .image(on: .iPhoneSe),
            file: file,
            testName: testName,
            line: line
        )

        SnapshotTesting.assertSnapshot(
            matching: sut,
            as: .image(on: .iPhoneX),
            file: file,
            testName: testName,
            line: line
        )
    }

    private func makeSut(
        username: String?,
        password: String?,
        prepare block: (RegistrationViewController) -> ()
    ) -> UINavigationController {
        let services = Services()
        let sut = RegistrationViewController.make(
            animator: services,
            delegate: services
        )

        sut.loadViewIfNeeded()

        sut.usernameTextField.text = username
        sut.passwordTextField.text = password
        sut.displayInitialState()

        block(sut)

        let nc = UINavigationController(rootViewController: sut)
        nc.navigationBar.prefersLargeTitles = true

        return nc
    }
}

private extension RegistrationViewController {
    func displayInitialState() {
        display(viewModel: .init(isLoading: false))
        display(viewModel: .init(title: "Register", isEnabled: false))
        display(viewModel: .init(title: "Registration"))
        display(viewModel: .init(message: nil))
    }

    func displayLoadingState() {
        usernameTextField.text = "my_login"
        passwordTextField.text = "password"
        display(viewModel: .init(title: "Register", isEnabled: true))
        display(viewModel: .init(isLoading: true))
    }

    func displayErrorState(message: String) {
        usernameTextField.text = "my_login"
        passwordTextField.text = "password"
        display(viewModel: .init(isLoading: false))
        display(viewModel: .init(title: "Register", isEnabled: true))
        display(viewModel: ErrorViewModel(message: message))
    }

    func displayRegisterButton(enabled: Bool) {
        display(viewModel: .init(title: "Register", isEnabled: enabled))
    }
}

private final class Services: Animator, RegistrationViewControllerDelegate {
    func onViewDidLoad() {}
    func onRegisterButtonTapped() {}
    func didUpdate(username: String?, password: String?) {}

    func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        animations()
        completion?()
    }
}
