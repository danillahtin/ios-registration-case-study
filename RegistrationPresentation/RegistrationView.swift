//
//  RegistrationView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct RegistrationViewModel: Equatable {
    public let cancelTitle: String
    public let nextTitle: String
    public let doneTitle: String
    public let usernamePlaceholder: String
    public let passwordPlaceholder: String

    public init(
        cancelTitle: String,
        nextTitle: String,
        doneTitle: String,
        usernamePlaceholder: String,
        passwordPlaceholder: String
    ) {
        self.cancelTitle = cancelTitle
        self.nextTitle = nextTitle
        self.doneTitle = doneTitle
        self.usernamePlaceholder = usernamePlaceholder
        self.passwordPlaceholder = passwordPlaceholder
    }
}

public protocol RegistrationView {
    func display(viewModel: RegistrationViewModel)
}
