//
//  SocialsPickerViewControllerSnapshotTests.swift
//  RegistrationSnapshotTests
//
//  Created by Danil Lahtin on 15.08.2021.
//

import XCTest
import SnapshotTesting
import RegistrationUI

final class SocialsPickerViewControllerSnapshotTests: XCTestCase {
    func test() {
        isRecording = true
        assertSnapshot(sut: makeSut())
        isRecording = false
    }

    // MARK: - Helpers

    private func makeSut() -> UIViewController {
        let sut = SocialsPickerViewController()
        sut.loadViewIfNeeded()

        return sut.wrappedInDemoContainer()
    }
}
