//
//  RequestValidatingDecorator.swift
//  Core
//
//  Created by Danil Lahtin on 07.08.2021.
//

public final class RequestValidatingDecorator: RegistrationService {
    private let decoratee: RegistrationService

    public init(_ decoratee: RegistrationService) {
        self.decoratee = decoratee
    }

    public func register(with request: RegistrationRequest) -> Result<Void, Error> {
        if request.username?.isEmpty ?? true {
            return .failure(RequestValidationError.emptyUsername)
        }

        if request.password?.isEmpty ?? true {
            return .failure(RequestValidationError.emptyPassword)
        }

        return decoratee.register(with: request)
    }
}
