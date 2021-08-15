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
        textFieldFactory: @escaping UsernamePasswordFormViewController.TextFieldFactory = UITextField.init,
        tapGestureRecognizerFactory: @escaping RegistrationViewController.TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        registrationService: RegistrationService,
        registerWithAppleService: RegisterWithAppleService,
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

        let formViewController = UsernamePasswordFormViewController.make(
            textFieldFactory: textFieldFactory,
            delegate: adapter
        )

        let animator = IfAttachedToWindowAnimatorDecorator(
            decoratee: animator,
            isAttachedToWindow: adapter.isAttachedToWindow
        )

        let errorViewController = ErrorViewController.make(animator: animator)

        let buttonViewController = ButtonViewController.make()
        buttonViewController.onButtonTappedBlock = adapter.onDoneButtonTapped

        let vc = RegistrationViewController.make(
            tapGestureRecognizerFactory: tapGestureRecognizerFactory,
            delegate: adapter,
            formViewController: formViewController,
            errorViewController: errorViewController,
            buttonViewController: buttonViewController
        )

        let buttonView = ButtonViewWhenViewLoadedDecorator(
            decoratee: ButtonViewComposite([
                Weak(buttonViewController),
                Weak(formViewController),
            ])
        )

        adapter.viewDidLoad = buttonView.viewLoaded
        adapter.viewController = vc
        adapter.formViewController = formViewController
        adapter.presenter = RegistrationPresenter(
            loadingView: Weak(buttonViewController),
            buttonView: buttonView,
            titleView: Weak(vc),
            registrationView: Weak(formViewController),
            errorView: Weak(errorViewController),
            scheduler: deferredUiScheduler,
            localizationProvider: localizationProvider
        )

        vc.registerWithApple = registerWithAppleService.register

        return vc
    }
}

private final class Adapter: RegistrationViewControllerDelegate, UsernamePasswordFormViewControllerDelegate {
    private let registrationService: RegistrationService
    private let uiScheduler: Scheduler
    private let serviceScheduler: Scheduler
    private let onRegister: () -> ()

    weak var viewController: RegistrationViewController?
    weak var formViewController: UsernamePasswordFormViewController?
    var presenter: RegistrationPresenter?
    var request: RegistrationRequest = .init(username: "", password: "")
    var viewDidLoad: () -> () = {}

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
        viewDidLoad()
    }

    func didCancelInput() {
        formViewController?.endEditing()
    }

    func didUpdate(username: String?, password: String?) {
        presenter?.didUpdate(username: username, password: password)
        request = RegistrationRequest(username: username, password: password)
    }

    func onDoneButtonTapped() {
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

    func isAttachedToWindow() -> Bool {
        viewController?.viewIfLoaded?.window != nil
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

private final class ButtonViewComposite: ButtonView {
    private let components: [ButtonView]

    init(_ components: [ButtonView]) {
        self.components = components
    }

    func display(viewModel: ButtonViewModel) {
        components.forEach({ $0.display(viewModel: viewModel) })
    }
}

private final class ButtonViewWhenViewLoadedDecorator: ButtonView {
    private let decoratee: ButtonView
    private var viewModel: ButtonViewModel?
    private var isViewLoaded = false

    init(decoratee: ButtonView) {
        self.decoratee = decoratee
    }

    func display(viewModel: ButtonViewModel) {
        if isViewLoaded {
            return decoratee.display(viewModel: viewModel)
        }

        self.viewModel = viewModel
    }

    func viewLoaded() {
        isViewLoaded = true
        viewModel.map(display)
    }
}
