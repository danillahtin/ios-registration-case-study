//
//  XCTestCase+Helpers.swift
//  CoreTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest

func makeError(_ message: String = "any") -> NSError {
    NSError(domain: "Some", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
}

extension XCTestCase {
    func trackForMemoryLeaks(_ object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, file: file, line: line)
        }
    }
}