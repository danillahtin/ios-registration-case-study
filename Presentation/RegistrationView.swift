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

    public init(cancelTitle: String, nextTitle: String, doneTitle: String) {
        self.cancelTitle = cancelTitle
        self.nextTitle = nextTitle
        self.doneTitle = doneTitle
    }
}

public protocol RegistrationView {
    func display(viewModel: RegistrationViewModel)
}
