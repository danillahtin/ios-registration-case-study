//
//  RequestValidatingDecoratorTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest
import Core

final class RequestValidatingDecorator {
    enum Error: Swift.Error {
        case emptyUsername
    }

    func register(with request: RegistrationRequest) -> Result<Void, Swift.Error> {
        return .failure(Error.emptyUsername)
    }
}

final class RequestValidatingDecoratorTests: XCTestCase {
    func test_givenRequestWithNilUsername_whenRegisterCalled_thenReturnsError() {
        let sut = makeSut()

        let result = sut.register(with: makeRequest(username: nil))

        XCTAssertThrowsError(try result.get())
    }

    // MARK: - Helpers

    private func makeSut() -> RequestValidatingDecorator {
        let sut = RequestValidatingDecorator()

        return sut
    }

    private func makeRequest(
        username: String? = "any",
        password: String? = "any"
    ) -> RegistrationRequest {
        RegistrationRequest(username: username, password: password)
    }
}
