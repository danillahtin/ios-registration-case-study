//
//  XCTestCase+Helpers.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 09.08.2021.
//

import XCTest
import SnapshotTesting

extension XCTestCase {
    func assertSnapshot(
        sut: UIViewController,
        configs: [ViewImageConfig] = [.iPhoneSe, .iPhoneX],
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        func assert() {
            configs.forEach { config in
                SnapshotTesting.assertSnapshot(
                    matching: sut,
                    as: .image(on: config),
                    file: file,
                    testName: testName,
                    line: line
                )
            }
        }

        assert()
        sut.overrideUserInterfaceStyle = .dark
        assert()
    }
}
