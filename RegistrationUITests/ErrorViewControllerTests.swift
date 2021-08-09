//
//  ErrorViewControllerTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 09.08.2021.
//

import XCTest
import XCTestHelpers
import RegistrationUI

final class ErrorViewControllerTests: XCTestCase {
    func test_givenErrorViewIsDisplayed_whenErrorViewButtonTapped_thenErrorViewIsNotDisplayed() {
        let sut = makeSut()

        XCTAssertEqual(sut.isErrorViewDisplayed, true)

        sut.simulateErrorViewTapped()
        XCTAssertEqual(sut.isErrorViewDisplayed, false)
    }

    func test_displayErrorViewModel_updatesErrorMessage() {
        let sut = makeSut()

        sut.display(viewModel: .init(message: "some message"))
        XCTAssertEqual(sut.errorMessage, "some message")

        sut.display(viewModel: .init(message: "another message"))
        XCTAssertEqual(sut.errorMessage, "another message")
    }

    func test_displayErrorViewModel_updatesErrorViewVisibility() {
        let sut = makeSut()

        sut.display(viewModel: .init(message: "some message"))
        XCTAssertEqual(sut.isErrorViewDisplayed, true)

        sut.display(viewModel: .init(message: nil))
        XCTAssertEqual(sut.isErrorViewDisplayed, false)

        sut.display(viewModel: .init(message: "another message"))
        XCTAssertEqual(sut.isErrorViewDisplayed, true)
    }

    // MARK: - Helpers

    private func makeSut(
        file: StaticString = #file,
        line: UInt = #line
    ) -> ErrorViewController {
        let animator = ImmediateAnimator()
        let sut = ErrorViewController.make(animator: animator)

        sut.loadViewIfNeeded()

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(animator, file: file, line: line)

        return sut
    }
}

private extension ErrorViewController {
    var isErrorViewDisplayed: Bool {
        errorView.alpha > 0
    }

    var errorMessage: String? {
        errorView.title(for: .normal)
    }

    func simulateErrorViewTapped() {
        errorView.simulateTap()
    }
}
