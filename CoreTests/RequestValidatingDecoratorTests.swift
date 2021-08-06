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
        if request.username?.isEmpty ?? true {
            return .failure(RequestValidationError.emptyUsername)
        }

        if request.password?.isEmpty ?? true {
            return .failure(RequestValidationError.emptyPassword)
        }

        return .success(())
    }
}

final class RequestValidatingDecoratorTests: XCTestCase {
    func test_givenRequestWithEmptyUsername_whenRegisterCalled_thenReturnsError() {
        assert(request: makeRequest(username: nil), returns: .failure(.emptyUsername))
        assert(request: makeRequest(username: ""), returns: .failure(.emptyUsername))
    }

    func test_givenRequestWithEmptyPassword_whenRegisterCalled_thenReturnsError() {
        assert(request: makeRequest(password: nil), returns: .failure(.emptyPassword))
        assert(request: makeRequest(password: ""), returns: .failure(.emptyPassword))
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

    private final class RegistrationServiceMock: RegistrationService {
        private let stub: Result<Void, Error>
        private(set) var requests: [RegistrationRequest] = []

        init(_ stub: Result<Void, Error> = .success(())) {
            self.stub = stub
        }

        func register(with request: RegistrationRequest) -> Result<Void, Error> {
            requests.append(request)

            return stub
        }
    }
}
