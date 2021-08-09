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
    public weak var errorView: UIButton! { view as? UIButton }
    private var animator: Animator!

    public static func make(animator: Animator) -> ErrorViewController {
        let vc = ErrorViewController()
        vc.animator = animator

        return vc
    }

    public override func loadView() {
        let errorView = UIButton()
        errorView.contentEdgeInsets = .init(top: 24, left: 16, bottom: 24, right: 16)
        errorView.setTitleColor(.white, for: .normal)
        errorView.backgroundColor = .systemPink
        errorView.titleLabel?.numberOfLines = 0
        errorView.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        errorView.titleLabel?.textAlignment = .center
        errorView.addTarget(self, action: #selector(onErrorViewTapped), for: .touchUpInside)

        view = errorView
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
    public weak var errorView: UIButton! { errorViewController.errorView }
    @IBOutlet private weak var registerButtonContainerView: UIView!

    private var tapGestureRecognizerFactory: TapGestureRecognizerFactory!
    private var delegate: RegistrationViewControllerDelegate!

    private var formViewController: UIViewController!
    private var errorViewController: ErrorViewController!

    public static func make(
        tapGestureRecognizerFactory: @escaping TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        delegate: RegistrationViewControllerDelegate,
        formViewController: UIViewController,
        errorViewController: ErrorViewController
    ) -> RegistrationViewController {
        let storyboard = UIStoryboard(
            name: "RegistrationViewController",
            bundle: .init(for: RegistrationViewController.self)
        )
        let vc = storyboard.instantiateInitialViewController() as! RegistrationViewController

        vc.tapGestureRecognizerFactory = tapGestureRecognizerFactory
        vc.delegate = delegate
        vc.formViewController = formViewController
        vc.errorViewController = errorViewController

        return vc
    }

    public override func loadView() {
        super.loadView()

        addFormViewController()
        addErrorViewController()

        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelInputRecongnizerRecognized))

        view.addGestureRecognizer(cancelInputTapRecognizer)
    }

    private func addChild(
        _ child: UIViewController,
        childLayoutBuilder: (UIView) -> [NSLayoutConstraint]
    ) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(childLayoutBuilder(child.view))
        child.didMove(toParent: self)
    }

    private func addFormViewController() {
        addChild(formViewController) {
            [
                view.layoutMarginsGuide.leftAnchor.constraint(equalTo: $0.leftAnchor),
                view.layoutMarginsGuide.rightAnchor.constraint(equalTo: $0.rightAnchor),
                view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: $0.topAnchor, constant: -16),
            ]
        }
    }

    private func addErrorViewController() {
        addChild(errorViewController) {
            [
                view.layoutMarginsGuide.leftAnchor.constraint(equalTo: $0.leftAnchor),
                view.layoutMarginsGuide.rightAnchor.constraint(equalTo: $0.rightAnchor),
                view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: $0.topAnchor, constant: -40),
            ]
        }
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
