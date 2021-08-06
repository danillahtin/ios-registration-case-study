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
        let sut = makeSut()

        let result = sut.register(with: makeRequest(username: nil))

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error as? RequestValidationError, .emptyUsername)
        }
    }

    func test_givenRequestWithNilPassword_whenRegisterCalled_thenReturnsError() {
        let sut = makeSut()

        let result = sut.register(with: makeRequest(password: nil))

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error as? RequestValidationError, .emptyPassword)
        }
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
