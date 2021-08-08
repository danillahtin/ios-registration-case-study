//
//  RegistrationViewPresenter.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

import Foundation

public final class RegistrationViewPresenter {
    private let loadingView: LoadingView
    private let buttonView: ButtonView
    private let titleView: TitleView
    private let registrationView: RegistrationView
    private let errorView: ErrorView

    private var buttonTitle: String { "Register" }

    public init(
        loadingView: LoadingView,
        buttonView: ButtonView,
        titleView: TitleView,
        registrationView: RegistrationView,
        errorView: ErrorView? = nil
    ) {
        self.loadingView = loadingView
        self.buttonView = buttonView
        self.titleView = titleView
        self.registrationView = registrationView
        self.errorView = errorView ?? ErrorViewStub()
    }

    public func didLoadView() {
        loadingView.display(viewModel: .init(isLoading: false))
        titleView.display(viewModel: .init(title: "Registration"))
        registrationView.display(viewModel: .init(cancelTitle: "Cancel", nextTitle: "Next", doneTitle: "Done"))
    }

    public func didUpdate(username: String?, password: String?) {
        let isUsernameEmpty = username?.isEmpty ?? true
        let isPasswordEmpty = password?.isEmpty ?? true

        buttonView.display(
            viewModel: .init(
                title: buttonTitle,
                isEnabled: !isUsernameEmpty && !isPasswordEmpty
            )
        )
    }

    public func didStartRegistration() {
        loadingView.display(viewModel: .init(isLoading: true))
    }

    public func didFinishRegistration() {
        loadingView.display(viewModel: .init(isLoading: false))
    }

    public func didFinishRegistration(with error: Error) {
        errorView.display(viewModel: .init(message: error.localizedDescription))
    }
}

private struct ErrorViewStub: ErrorView {
    func display(viewModel: ErrorViewModel) {

    }
}
