//
//  ButtonViewControllerSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class ButtonViewControllerSnapshotTests: XCTestCase {
    func test_enabled() {
        assertSnapshot(isEnabled: true)
    }

    func test_disabled() {
        assertSnapshot(isEnabled: false)
    }

    func test_loading() {
        assertSnapshot(isLoading: true)
    }

    // MARK: - Helpers

    private func assertSnapshot(
        isEnabled: Bool = true,
        isLoading: Bool = false,
        prepare block: (ButtonViewController) -> () = { _ in },
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let sut = makeSut(isEnabled: isEnabled, isLoading: isLoading, prepare: block)
        assertSnapshot(sut: sut, file: file, testName: testName, line: line)
    }

    private func makeSut(
        isEnabled: Bool = true,
        isLoading: Bool = false,
        prepare block: (ButtonViewController) -> ()
    ) -> UIViewController {
        let sut = ButtonViewController.make()
        sut.loadViewIfNeeded()
        sut.display(viewModel: .init(title: "Button", isEnabled: isEnabled))
        sut.display(viewModel: .init(isLoading: isLoading))

        block(sut)

        return sut.wrappedInDemoContainer()
    }
}
