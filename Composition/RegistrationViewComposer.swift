//
//  RegistrationViewComposer.swift
//  Composition
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit
import Core
import Presentation
import UI

public enum RegistrationViewComposer {
    public typealias OnRegisterBlock = () -> ()
    public typealias OnErrorBlock = (Error) -> ()

    public static func composed(
        textFieldFactory: @escaping RegistrationViewController.TextFieldFactory = UITextField.init,
        tapGestureRecognizerFactory: @escaping RegistrationViewController.TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        registrationService: RegistrationService,
        uiScheduler: Scheduler = DispatchQueue.main,
        serviceScheduler: Scheduler,
        onRegister: @escaping OnRegisterBlock,
        onError: @escaping OnErrorBlock
    ) -> RegistrationViewController {
        let adapter = Adapter(
            registrationService: registrationService,
            uiScheduler: uiScheduler,
            serviceScheduler: serviceScheduler,
            onRegister: onRegister,
            onError: onError
        )

        let vc = RegistrationViewController(
            textFieldFactory: textFieldFactory,
            tapGestureRecognizerFactory: tapGestureRecognizerFactory,
            delegate: adapter
        )

        adapter.presenter = RegistrationViewPresenter(
            loadingView: Weak(vc),
            buttonView: Weak(vc),
            titleView: Weak(vc),
            registrationView: Weak(vc),
            errorView: Weak(vc)
        )

        return vc
    }
}

private final class Adapter: RegistrationViewControllerDelegate {
    private let registrationService: RegistrationService
    private let uiScheduler: Scheduler
    private let serviceScheduler: Scheduler
    private let onRegister: () -> ()
    private let onError: (Error) -> ()

    var presenter: RegistrationViewPresenter?
    var request: RegistrationRequest = .init(username: nil, password: nil)

    init(
        registrationService: RegistrationService,
        uiScheduler: Scheduler,
        serviceScheduler: Scheduler,
        onRegister: @escaping () -> (),
        onError: @escaping (Error) -> ()
    ) {
        self.registrationService = registrationService
        self.uiScheduler = uiScheduler
        self.serviceScheduler = serviceScheduler
        self.onRegister = onRegister
        self.onError = onError
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
                self?.onError(error)
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
