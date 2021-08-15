//
//  RegistrationViewControllerSnapshotTests.swift
//  RegistrationSnapshotTests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class RegistrationViewControllerSnapshotTests: XCTestCase {
    func test() {
        assertSnapshot(sut: makeSut())
    }

    // MARK: - Helpers

    private func makeSut() -> UIViewController {
        let sut = RegistrationViewController.make(
            delegate: Services(),
            formViewController: .init(view: makeView(name: "Form", color: .blue, height: 300)),
            errorViewController: .init(view: makeView(name: "Error", color: .red, height: 120)),
            buttonViewController: .init(view: makeView(name: "Button", color: .systemIndigo, height: 60)),
            socialsPickerViewController: UIViewController()
        )

        sut.loadViewIfNeeded()

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

private final class Services: RegistrationViewControllerDelegate {
    func onViewDidLoad() {}
    func didCancelInput() {}
}
