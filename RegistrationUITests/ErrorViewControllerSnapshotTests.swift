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

private final class ImmediateAnimator: Animator {
    func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        animations()
        completion?()
    }
}
