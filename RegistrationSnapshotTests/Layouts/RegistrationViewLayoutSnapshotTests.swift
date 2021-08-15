//
//  RegistrationViewLayoutSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class RegistrationViewLayoutSnapshotTests: XCTestCase {
    func test() {
        assertSnapshot(sut: makeSut())
    }

    // MARK: - Helpers

    private func makeSut() -> UIViewController {
        let container = makeView(name: "container", color: .white)
        let form = makeView(name: "form", color: .blue, height: 300)
        let socials = makeView(name: "socials", color: .green, height: 44)
        let button = makeView(name: "button", color: .systemIndigo, height: 60)
        let error = makeView(name: "error", color: .red, height: 100)

        RegistrationViewLayout(
            container: container,
            form: form,
            button: button,
            socials: socials,
            error: error
        ).apply()

        let sut = UIViewController()
        sut.view = container

        return sut
    }
}
