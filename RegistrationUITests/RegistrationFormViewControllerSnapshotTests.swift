//
//  RegistrationFormViewControllerSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 09.08.2021.
//

import SnapshotTesting
import XCTest
import RegistrationUI

final class RegistrationFormViewControllerSnapshotTests: XCTestCase {
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
        prepare block: (RegistrationFormViewController) -> () = { _ in },
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
        prepare block: (RegistrationFormViewController) -> ()
    ) -> UIViewController {
        let services = Services()
        let sut = RegistrationFormViewController.make(delegate: services)

        sut.loadViewIfNeeded()

        sut.usernameTextField.text = username
        sut.passwordTextField.text = password
        sut.displayInitialState()

        let parent = UIViewController()
        parent.view.backgroundColor = UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? .black : .white
        })
        parent.addChild(sut)
        parent.view.addSubview(sut.view)
        sut.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            parent.view.layoutMarginsGuide.leftAnchor.constraint(equalTo: sut.view.leftAnchor),
            parent.view.layoutMarginsGuide.rightAnchor.constraint(equalTo: sut.view.rightAnchor),
            parent.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: sut.view.topAnchor),
        ])

        sut.didMove(toParent: parent)

        block(sut)

        return parent
    }
}

private extension RegistrationFormViewController {
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

private final class Services: RegistrationFormViewControllerDelegate {
    func didUpdate(username: String?, password: String?) {}
    func onRegisterButtonTapped() {}
}
