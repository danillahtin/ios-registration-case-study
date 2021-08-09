//
//  UsernamePasswordFormViewControllerSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 09.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class UsernamePasswordFormViewControllerSnapshotTests: XCTestCase {
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

    // MARK: - Helpers

    private func assertSnapshot(
        username: String? = nil,
        password: String? = nil,
        prepare block: (UsernamePasswordFormViewController) -> () = { _ in },
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let sut = makeSut(username: username, password: password, prepare: block)
        assertSnapshot(sut: sut, file: file, testName: testName, line: line)
    }

    private func makeSut(
        username: String?,
        password: String?,
        prepare block: (UsernamePasswordFormViewController) -> ()
    ) -> UIViewController {
        let services = Services()
        let sut = UsernamePasswordFormViewController.make(delegate: services)

        sut.loadViewIfNeeded()

        sut.usernameTextField.text = username
        sut.passwordTextField.text = password
        sut.displayInitialState()

        block(sut)

        return sut.wrappedInDemoContainer()
    }
}

private extension UsernamePasswordFormViewController {
    func displayInitialState() {
        display(
            viewModel: .init(
                cancelTitle: "Cancel",
                nextTitle: "Next",
                doneTitle: "Done",
                usernamePlaceholder: "Username",
                passwordPlaceholder: "Password"
            )
        )
    }
}

private final class Services: UsernamePasswordFormViewControllerDelegate {
    func didUpdate(username: String?, password: String?) {}
    func onDoneButtonTapped() {}
}
