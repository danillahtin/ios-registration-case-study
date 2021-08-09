//
//  ErrorViewLayoutSnapshotTests.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class ErrorViewLayoutSnapshotTests: XCTestCase {
    func test() {
        assertSnapshot(sut: makeSut())
    }

    // MARK: - Helpers

    private func makeSut() -> UIViewController {
        let container = makeView(name: "container", color: .white)
        let error = makeView(name: "error", color: .red, height: 100)

        ErrorViewLayout(container: container, error: error).apply()

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
