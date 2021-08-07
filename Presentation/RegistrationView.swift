//
//  RegistrationView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct RegistrationViewModel {
    public let cancelTitle: String
    public let nextTitle: String
    public let doneTitle: String
}

public protocol RegistrationView {
    func display(viewModel: RegistrationViewModel)
}
