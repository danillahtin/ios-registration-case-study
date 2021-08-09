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
        let button = makeView(name: "button", color: .systemIndigo, height: 60)
        let error = makeView(name: "error", color: .red, height: 100)

        RegistrationViewLayout(container: container, form: form, button: button, error: error).apply()

        let sut = UIViewController()
        sut.view = container

        return sut
    }

    private func makeView(name: String, color: UIColor, height: CGFloat? = nil) -> UIView {
        let label = UILabel()
        label.backgroundColor = color
        label.text = name
        label.textAlignment = .center
        label.textColor = .black
        height.map({ label.heightAnchor.constraint(equalToConstant: $0).isActive = true })

        return label
    }
}
