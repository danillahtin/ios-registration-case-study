//
//  SocialsPickerViewControllerTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 15.08.2021.
//

import XCTest
import XCTestHelpers
import RegistrationUI

final class SocialsPickerViewControllerTests: XCTestCase {
    func test_whenAppleButtonTapped_thenCallbackIsCalled() {
        let sut = makeSut()

        var callCount = 0
        sut.didTapAppleButton = { callCount += 1 }

        XCTAssertEqual(callCount, 0)

        sut.simulateAppleButtonTapped()
        XCTAssertEqual(callCount, 1)

        sut.simulateAppleButtonTapped()
        XCTAssertEqual(callCount, 2)
    }

    // MARK: - Helpers

    private func makeSut(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SocialsPickerViewController {
        let sut = SocialsPickerViewController()

        sut.loadViewIfNeeded()

        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }
}

private extension SocialsPickerViewController {
    func simulateAppleButtonTapped() {
        appleButton.simulateTap()
    }
}
