//
//  RegistrationRequest.swift
//  Multiplatform
//
//  Created by Danil Lahtin on 07.08.2021.
//

public struct RegistrationRequest: Equatable {
    public let username: String?
    public let password: String?

    public init(
        username: String?,
        password: String?
    ) {
        self.username = username
        self.password = password
    }
}
