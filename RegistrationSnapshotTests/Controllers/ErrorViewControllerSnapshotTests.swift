//
//  ErrorViewControllerSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class ErrorViewControllerSnapshotTests: XCTestCase {
    func test_noMessage() {
        assertSnapshot(message: nil)
    }

    func test_shortMessage() {
        assertSnapshot(message: "Short message")
    }

    func test_longMessage() {
        assertSnapshot(message: "Very very very very very very very very very very long message")
    }

    // MARK: - Helpers

    private func assertSnapshot(
        message: String?,
        prepare block: (ErrorViewController) -> () = { _ in },
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let sut = makeSut(message: message, prepare: block)
        assertSnapshot(sut: sut, file: file, testName: testName, line: line)
    }

    private func makeSut(
        message: String?,
        prepare block: (ErrorViewController) -> ()
    ) -> UIViewController {
        let sut = ErrorViewController.make(animator: ImmediateAnimator())
        sut.loadViewIfNeeded()
        sut.display(viewModel: .init(message: message))

        block(sut)

        return sut.wrappedInDemoContainer()
    }
}

private final class ImmediateAnimator: Animator {
    func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        animations()
        completion?()
    }
}
