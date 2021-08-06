//
//  RequestValidatingDecoratorTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest
import Core

enum RequestValidationError: Error {
    case emptyUsername
    case emptyPassword
}

final class RequestValidatingDecorator {
    func register(with request: RegistrationRequest) -> Result<Void, Error> {
        guard request.username != nil else {
            return .failure(RequestValidationError.emptyUsername)
        }

        guard request.password != nil else {
            return .failure(RequestValidationError.emptyPassword)
        }

        return .success(())
    }
}

final class RequestValidatingDecoratorTests: XCTestCase {
    func test_givenRequestWithNilUsername_whenRegisterCalled_thenReturnsError() {
        assert(request: makeRequest(username: nil), returns: .failure(.emptyUsername))
    }

    func test_givenRequestWithNilPassword_whenRegisterCalled_thenReturnsError() {
        assert(request: makeRequest(password: nil), returns: .failure(.emptyPassword))
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

    private func assert(
        request: RegistrationRequest,
        returns expectedResult: Result<Void, RequestValidationError>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let sut = makeSut()
        let result = sut.register(with: request)

        switch (result, expectedResult) {
        case (.success, .failure), (.failure, .success):
            XCTFail("Expected to return \(expectedResult), got \(result) instead", file: file, line: line)
        case (.success, .success):
            break
        case (.failure(let error), .failure(let expectedError)):
            XCTAssertEqual(
                error as NSError,
                expectedError as NSError,
                "Expected to fail with error \(expectedError), got \(error) instead",
                file: file,
                line: line
            )
        }
    }
}
