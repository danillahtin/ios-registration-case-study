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

    override func loadView() {
        let view = UIView()

        let usernameTextField = UITextField()
        let passwordTextField = UITextField()

        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)

        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField
        self.view = view

        self.title = "Registration"
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
}
