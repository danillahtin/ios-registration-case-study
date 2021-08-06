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
    private let decoratee: RegistrationService

    init(_ decoratee: RegistrationService) {
        self.decoratee = decoratee
    }

    func register(with request: RegistrationRequest) -> Result<Void, Error> {
        if request.username?.isEmpty ?? true {
            return .failure(RequestValidationError.emptyUsername)
        }

        if request.password?.isEmpty ?? true {
            return .failure(RequestValidationError.emptyPassword)
        }

        return decoratee.register(with: request)
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

    func test_givenRequestWithNonEmptyUsernameAndPassword_whenRegisterCalled_thenDecorateeIsCalled() {
        let (sut, decoratee) = makeSut()

        _ = sut.register(with: makeRequest(username: "some username", password: "some password"))
        XCTAssertEqual(decoratee.requests, [makeRequest(username: "some username", password: "some password")])

        _ = sut.register(with: makeRequest(username: "another username", password: "another password"))
        XCTAssertEqual(decoratee.requests, [
            makeRequest(username: "some username", password: "some password"),
            makeRequest(username: "another username", password: "another password")
        ])
    }

    func test_givenCorrectRequest_whenRegisterCalled_thenReturnsDecorateeResult() {
        let (sut, decoratee) = makeSut()

        decoratee.stub(result: .success)
        XCTAssertEqual(sut.register(with: makeRequest()).toEquatable(), .success)

        decoratee.stub(result: .failure(RequestValidationError.emptyUsername))
        XCTAssertEqual(sut.register(with: makeRequest()).toEquatable(),
                       .failure(RequestValidationError.emptyUsername as NSError))
    }

    // MARK: - Helpers

    private func makeSut() -> (sut: RequestValidatingDecorator, decoratee: RegistrationServiceMock) {
        let decoratee = RegistrationServiceMock()
        let sut = RequestValidatingDecorator(decoratee)

        return (sut, decoratee)
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
        let (sut, _) = makeSut()
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
        private var stub: Result<Void, Error>?
        private(set) var requests: [RegistrationRequest] = []

        func stub(result: Result<Void, Error>) {
            stub = result
        }

        func register(with request: RegistrationRequest) -> Result<Void, Error> {
            requests.append(request)

            return stub ?? .success(())
        }
    }
}

private struct EquatableVoid: Equatable {}

private extension Result where Success == Void {
    static var success: Self { .success(()) }

    func toEquatable() -> Result<EquatableVoid, NSError> {
        map({ _ in EquatableVoid() })
            .mapError({ $0 as NSError })
    }
}

private extension Result where Success == EquatableVoid {
    static var success: Self { .success(.init()) }
}
