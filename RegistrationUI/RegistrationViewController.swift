//
//  RegistrationViewController.swift
//  UI
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit
import RegistrationPresentation

public protocol RegistrationViewControllerDelegate {
    func onViewDidLoad()
    func onRegisterButtonTapped()
    func didCancelInput()
}

public final class ErrorViewController: UIViewController {
    weak var errorView: UIButton! {
        didSet {
            errorView.addTarget(self, action: #selector(onErrorViewTapped), for: .touchUpInside)
            errorView.titleLabel?.textAlignment = .center
        }
    }

    private var animator: Animator!

    static func make(animator: Animator) -> ErrorViewController {
        let vc = ErrorViewController()
        vc.animator = animator

        return vc
    }

    @objc
    private func onErrorViewTapped() {
        hideErrorView()
    }

    private func hideErrorView() {
        animator.animate { [weak self] in
            self?.errorView.alpha = 0
        }
    }

    private func showErrorView(message: String) {
        errorView.setTitle(message, for: .normal)
        animator.animate { [weak self] in
            self?.errorView.alpha = 1
        }
    }
}

extension ErrorViewController: ErrorView {
    public func display(viewModel: ErrorViewModel) {
        if let message = viewModel.message {
            showErrorView(message: message)
        } else {
            hideErrorView()
        }
    }
}

public final class RegistrationViewController: UIViewController {
    public typealias TapGestureRecognizerFactory = (_ target: Any?, _ action: Selector?) -> UITapGestureRecognizer

    @IBOutlet public private(set) weak var registerButton: UIButton!
    @IBOutlet public private(set) weak var registerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet public private(set) weak var errorView: UIButton!
    @IBOutlet private weak var registerButtonContainerView: UIView!

    private var tapGestureRecognizerFactory: TapGestureRecognizerFactory!
    private var delegate: RegistrationViewControllerDelegate!

    private var formViewController: UIViewController!
    private var errorViewController: ErrorViewController!

    public static func make(
        tapGestureRecognizerFactory: @escaping TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        animator: Animator,
        delegate: RegistrationViewControllerDelegate,
        formViewController: UIViewController
    ) -> RegistrationViewController {
        let storyboard = UIStoryboard(
            name: "RegistrationViewController",
            bundle: .init(for: RegistrationViewController.self)
        )
        let vc = storyboard.instantiateInitialViewController() as! RegistrationViewController

        vc.tapGestureRecognizerFactory = tapGestureRecognizerFactory
        vc.delegate = delegate
        vc.formViewController = formViewController
        vc.errorViewController = ErrorViewController.make(animator: animator)

        return vc
    }

    public override func loadView() {
        super.loadView()

        errorViewController.errorView = errorView

        addFormViewController()

        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelInputRecongnizerRecognized))

        view.addGestureRecognizer(cancelInputTapRecognizer)
    }

    private func addFormViewController() {
        addChild(formViewController)
        view.insertSubview(formViewController.view, belowSubview: errorView)
        formViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.layoutMarginsGuide.leftAnchor.constraint(equalTo: formViewController.view.leftAnchor),
            view.layoutMarginsGuide.rightAnchor.constraint(equalTo: formViewController.view.rightAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: formViewController.view.topAnchor, constant: -16),
        ])

        formViewController.didMove(toParent: self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        delegate?.onViewDidLoad()
    }

    @IBAction
    private func onRegisterButtonTapped() {
        delegate?.onRegisterButtonTapped()
    }

    @objc
    private func onCancelInputRecongnizerRecognized() {
        delegate?.didCancelInput()
    }
}

extension RegistrationViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            registerActivityIndicator.startAnimating()
            registerButton.isHidden = true
        } else {
            registerActivityIndicator.stopAnimating()
            registerButton.isHidden = false
        }
    }
}

extension RegistrationViewController: ButtonView {
    public func display(viewModel: ButtonViewModel) {
        registerButton.setTitle(viewModel.title, for: .normal)
        registerButton.isEnabled = viewModel.isEnabled
        registerButtonContainerView.backgroundColor = viewModel.isEnabled
            ? registerButtonContainerView.backgroundColor?.withAlphaComponent(1)
            : registerButtonContainerView.backgroundColor?.withAlphaComponent(0.4)
    }
}

extension RegistrationViewController: TitleView {
    public func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}

extension RegistrationViewController: ErrorView {
    public func display(viewModel: ErrorViewModel) {
        errorViewController.display(viewModel: viewModel)
    }
}
