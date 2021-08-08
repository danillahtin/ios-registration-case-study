//
//  ErrorView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct ErrorViewModel: Equatable {
    public let message: String?

    public init(message: String?) {
        self.message = message
    }
}

public protocol ErrorView {
    func display(viewModel: ErrorViewModel)
}
