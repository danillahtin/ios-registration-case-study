//
//  RegistrationPresenter.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public final class RegistrationPresenter {
    private let loadingView: LoadingView
    private let buttonView: ButtonView
    private let titleView: TitleView
    private let registrationView: RegistrationView
    private let errorView: ErrorView
    private let scheduler: DeferredScheduler
    private let localizationProvider: LocalizationProvider

    private var hideErrorCancellable: Cancellable?

    public init(
        loadingView: LoadingView,
        buttonView: ButtonView,
        titleView: TitleView,
        registrationView: RegistrationView,
        errorView: ErrorView,
        scheduler: DeferredScheduler,
        localizationProvider: LocalizationProvider
    ) {
        self.loadingView = loadingView
        self.buttonView = buttonView
        self.titleView = titleView
        self.registrationView = registrationView
        self.errorView = errorView
        self.scheduler = scheduler
        self.localizationProvider = localizationProvider
    }

    public func didLoadView() {
        loadingView.display(viewModel: .init(isLoading: false))
        titleView.display(viewModel: .init(title: localizationProvider.title))
        registrationView.display(
            viewModel: .init(
                cancelTitle: localizationProvider.cancel,
                nextTitle: localizationProvider.next,
                doneTitle: localizationProvider.done,
                usernamePlaceholder: localizationProvider.usernamePlaceholder,
                passwordPlaceholder: localizationProvider.passwordPlaceholder
            )
        )
    }

    public func didUpdate(username: String?, password: String?) {
        let isUsernameEmpty = username?.isEmpty ?? true
        let isPasswordEmpty = password?.isEmpty ?? true

        buttonView.display(
            viewModel: .init(
                title: localizationProvider.register,
                isEnabled: !isUsernameEmpty && !isPasswordEmpty
            )
        )
        errorView.display(viewModel: .init(message: nil))
    }

    public func didStartRegistration() {
        errorView.display(viewModel: .init(message: nil))
        loadingView.display(viewModel: .init(isLoading: true))
    }

    public func didFinishRegistration() {
        loadingView.display(viewModel: .init(isLoading: false))
    }

    public func didFinishRegistration(with error: Error) {
        hideErrorCancellable?.cancel()
        errorView.display(viewModel: .init(message: error.localizedDescription))
        loadingView.display(viewModel: .init(isLoading: false))
        hideErrorCancellable = scheduler.schedule(after: 5, { [weak self] in
            self?.errorView.display(viewModel: .init(message: .none))
        })
    }
}

private extension LocalizationProvider {
    var title: String {
        string(for: "REGISTRATION_VIEW_TITLE")
    }

    var cancel: String {
        string(for: "REGISTRATION_CANCEL_TITLE")
    }

    var next: String {
        string(for: "REGISTRATION_NEXT_TITLE")
    }

    var done: String {
        string(for: "REGISTRATION_DONE_TITLE")
    }

    var register: String {
        string(for: "REGISTRATION_REGISTER_BUTTON_TITLE")
    }

    var usernamePlaceholder: String {
        string(for: "REGISTRATION_USERNAME_PLACEHOLDER")
    }

    var passwordPlaceholder: String {
        string(for: "REGISTRATION_PASSWORD_PLACEHOLDER")
    }
}
