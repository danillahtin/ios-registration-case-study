//
//  RegistrationViewControllerSnapshotTests.swift
//  UITests
//
//  Created by Danil Lahtin on 08.08.2021.
//

import SnapshotTesting
import XCTest
import UI

final class RegistrationViewControllerSnapshotTests: XCTestCase {
    func test_initialState() {
        assertSnapshot { $0.displayInitialState() }
    }

    // MARK: - Helpers

    private func assertSnapshot(
        username: String? = nil,
        password: String? = nil,
        prepare block: (RegistrationViewController) -> (),
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
        username: String? = nil,
        password: String? = nil,
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

        block(sut)

        let nc = UINavigationController(rootViewController: sut)
        nc.navigationBar.prefersLargeTitles = true

        return nc
    }
}

private extension RegistrationViewController {
    func displayInitialState() {
        display(viewModel: .init(isLoading: false))
        display(viewModel: .init(title: "Register", isEnabled: true))
        display(viewModel: .init(title: "Registration"))
        display(viewModel: .init(message: nil))
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
