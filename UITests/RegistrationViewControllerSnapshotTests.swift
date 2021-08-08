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
    func test() {
        let sut = makeSut()
        sut.displayInitialState()

        isRecording = true
        assertSnapshot(
            matching: sut.wrappedInNavigationController(),
            as: .image(on: .iPhoneSe)
        )

        assertSnapshot(
            matching: sut.wrappedInNavigationController(),
            as: .image(on: .iPhoneX)
        )
    }

    // MARK: - Helpers

    private func makeSut(username: String? = nil, password: String? = nil) -> RegistrationViewController {
        let services = Services()
        let sut = RegistrationViewController.make(
            animator: services,
            delegate: services
        )

        sut.loadViewIfNeeded()

        sut.usernameTextField.text = username
        sut.passwordTextField.text = password

        return sut
    }
}

private extension RegistrationViewController {
    func wrappedInNavigationController() -> UIViewController {
        UINavigationController(rootViewController: self)
    }

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
