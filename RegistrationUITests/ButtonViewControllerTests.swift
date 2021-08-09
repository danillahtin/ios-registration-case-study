//
//  ButtonViewControllerTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import XCTestHelpers
import RegistrationPresentation
import RegistrationUI

final class ButtonViewControllerTests: XCTestCase {
    func test_whenButtonTapped_thenBlockIsCalled() {
        let sut = makeSut()

        var buttonTappedCount = 0
        sut.onButtonTappedBlock = { buttonTappedCount += 1 }

        XCTAssertEqual(buttonTappedCount, 0)
        sut.simulateButtonTapped()

        XCTAssertEqual(buttonTappedCount, 1)
    }

    func test_displayLoadingViewModel_updatesActivityIndicator() {
        let sut = makeSut()

        XCTAssertEqual(sut.isAnimating, false)

        sut.display(viewModel: .init(isLoading: true))
        XCTAssertEqual(sut.isAnimating, true)

        sut.display(viewModel: .init(isLoading: false))
        XCTAssertEqual(sut.isAnimating, false)
    }

    func test_displayLoadingViewModel_updatesButtonVisibility() {
        let sut = makeSut()

        XCTAssertEqual(sut.isButtonHidden, false)

        sut.display(viewModel: .init(isLoading: true))
        XCTAssertEqual(sut.isButtonHidden, true)

        sut.display(viewModel: .init(isLoading: false))
        XCTAssertEqual(sut.isButtonHidden, false)
    }

    func test_displayButtonViewModel_updatesButtonIsEnabled() {
        let sut = makeSut()

        XCTAssertEqual(sut.isButtonEnabled, true)

        sut.display(viewModel: .make(isEnabled: false))
        XCTAssertEqual(sut.isButtonEnabled, false)

        sut.display(viewModel: .make(isEnabled: true))
        XCTAssertEqual(sut.isButtonEnabled, true)
    }

    func test_displayButtonViewModel_updatesButtonTitle() {
        let sut = makeSut()

        sut.display(viewModel: .make(title: "some title"))
        XCTAssertEqual(sut.buttonTitle, "some title")

        sut.display(viewModel: .make(title: "another title"))
        XCTAssertEqual(sut.buttonTitle, "another title")
    }

    // MARK: - Helpers

    private func makeSut(
        file: StaticString = #file,
        line: UInt = #line
    ) -> ButtonViewController {
        let sut = ButtonViewController.make()

        sut.loadViewIfNeeded()

        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }
}

private extension ButtonViewController {
    var isAnimating: Bool {
        activityIndicator.isAnimating
    }

    var isButtonHidden: Bool {
        button.isHidden
    }

    var isButtonEnabled: Bool {
        button.isEnabled
    }

    var buttonTitle: String? {
        button.title(for: .normal)
    }

    func simulateButtonTapped() {
        button.simulateTap()
    }
}
