//
//  BottomButtonLayoutSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class BottomButtonLayoutSnapshotTests: XCTestCase {
    func test() {
        assertSnapshot(sut: makeSut())
    }

    // MARK: - Helpers

    private func makeSut() -> UIViewController {
        let container = makeView(name: "container", color: .white)
        let button = makeView(name: "button", color: .systemIndigo, height: 60)

        BottomButtonLayout(container: container, button: button).apply()

        let sut = UIViewController()
        sut.view = container

        return sut
    }
}
