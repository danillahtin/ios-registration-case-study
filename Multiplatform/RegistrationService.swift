//
//  RegistrationService.swift
//  Multiplatform
//
//  Created by Danil Lahtin on 07.08.2021.
//

public protocol RegistrationService {
    func register(with request: RegistrationRequest) -> Result<Void, Error>
}
