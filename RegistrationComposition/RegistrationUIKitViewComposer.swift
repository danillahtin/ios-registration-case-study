//
//  RegistrationUIKitViewComposer.swift
//  Composition
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit
import RegistrationCore
import RegistrationPresentation
import RegistrationUI

public enum RegistrationUIKitViewComposer {
    public typealias OnRegisterBlock = () -> ()

    public static func composed(
        textFieldFactory: @escaping RegistrationViewController.TextFieldFactory = UITextField.init,
        tapGestureRecognizerFactory: @escaping RegistrationViewController.TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        registrationService: RegistrationService,
        localizationProvider: LocalizationProvider = DefaultLocalizationProvider(),
        uiScheduler: Scheduler = DispatchQueue.main,
        deferredUiScheduler: DeferredScheduler = DispatchQueue.main,
        serviceScheduler: Scheduler,
        animator: Animator = UIKitAnimator.fast,
        onRegister: @escaping OnRegisterBlock
    ) -> RegistrationViewController {
        let adapter = Adapter(
            registrationService: registrationService,
            uiScheduler: uiScheduler,
            serviceScheduler: serviceScheduler,
            onRegister: onRegister
        )

        let formViewController = RegistrationFormViewController.make(
            textFieldFactory: textFieldFactory,
            delegate: adapter
        )

        let vc = RegistrationViewController.make(
            tapGestureRecognizerFactory: tapGestureRecognizerFactory,
            animator: animator,
            delegate: adapter,
            formViewController: formViewController
        )

        adapter.presenter = RegistrationPresenter(
            loadingView: Weak(vc),
            buttonView: Weak(vc),
            titleView: Weak(vc),
            registrationView: Weak(vc),
            errorView: Weak(vc),
            scheduler: deferredUiScheduler,
            localizationProvider: localizationProvider
        )

        return vc
    }
}

private final class Adapter: RegistrationViewControllerDelegate, RegistrationFormViewControllerDelegate {
    private let registrationService: RegistrationService
    private let uiScheduler: Scheduler
    private let serviceScheduler: Scheduler
    private let onRegister: () -> ()

    var presenter: RegistrationPresenter?
    var request: RegistrationRequest = .init(username: "", password: "")

    init(
        registrationService: RegistrationService,
        uiScheduler: Scheduler,
        serviceScheduler: Scheduler,
        onRegister: @escaping () -> ()
    ) {
        self.registrationService = registrationService
        self.uiScheduler = uiScheduler
        self.serviceScheduler = serviceScheduler
        self.onRegister = onRegister
    }

    func onViewDidLoad() {
        presenter?.didLoadView()
    }

    func didUpdate(username: String?, password: String?) {
        presenter?.didUpdate(username: username, password: password)
        request = RegistrationRequest(username: username, password: password)
    }

    func onRegisterButtonTapped() {
        presenter?.didStartRegistration()

        serviceScheduler.schedule { [weak self, request] in
            switch self?.registrationService.register(with: request) {
            case .success:
                self?.uiScheduler.schedule {
                    self?.presenter?.didFinishRegistration()
                }
                self?.onRegister()
            case .failure(let error):
                self?.uiScheduler.schedule {
                    self?.presenter?.didFinishRegistration(with: error)
                }
            case .none:
                break
            }
        }
    }
}

extension Weak: LoadingView where Object: LoadingView {
    func display(viewModel: LoadingViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension Weak: ButtonView where Object: ButtonView {
    func display(viewModel: ButtonViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension Weak: TitleView where Object: TitleView {
    func display(viewModel: TitleViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension Weak: RegistrationView where Object: RegistrationView {
    func display(viewModel: RegistrationViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension Weak: ErrorView where Object: ErrorView {
    func display(viewModel: ErrorViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension DispatchWorkItem: Cancellable {}

extension DispatchQueue: DeferredScheduler {
    public func schedule(after: TimeInterval, _ work: @escaping () -> ()) -> Cancellable {
        let work = DispatchWorkItem(block: work)

        self.asyncAfter(deadline: .now() + .milliseconds(Int(after * 1000)), execute: work)

        return work
    }
}
