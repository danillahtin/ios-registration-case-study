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

    override func loadView() {
        let view = UIView()

        let usernameTextField = UITextField()

        view.addSubview(usernameTextField)

        self.usernameTextField = usernameTextField
        self.view = view
    }
}

final class IntegrationTests: XCTestCase {
    func test_loadView_displaysEmptyUsername() {
        let sut = makeSut()

        XCTAssertEqual(sut.username, "")
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
}
