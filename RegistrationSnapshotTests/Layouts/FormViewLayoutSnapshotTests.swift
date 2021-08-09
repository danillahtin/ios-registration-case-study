//
//  FormViewLayoutSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class FormViewLayoutSnapshotTests: XCTestCase {
    func test() {
        assertSnapshot(sut: makeSut())
    }

    // MARK: - Helpers

    private func makeSut() -> UIViewController {
        let container = makeView(name: "container", color: .white)
        let form = makeView(name: "form", color: .blue, height: 300)

        FormViewLayout(container: container, form: form).apply()

        let sut = UIViewController()
        sut.view = container

        return sut
    }
}
