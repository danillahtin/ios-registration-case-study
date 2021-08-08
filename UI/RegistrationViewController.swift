//
//  RegistrationViewController.swift
//  UI
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit
import Presentation

public protocol RegistrationViewControllerDelegate {
    func onViewDidLoad()
    func onRegisterButtonTapped()
    func didUpdate(username: String?, password: String?)
}

public final class RegistrationViewController: UIViewController {
    public typealias TextFieldFactory = () -> UITextField
    public typealias TapGestureRecognizerFactory = (_ target: Any?, _ action: Selector?) -> UITapGestureRecognizer

    @IBOutlet public private(set) weak var registerButton: UIButton!
    @IBOutlet public private(set) weak var registerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet public private(set) weak var errorView: UIButton!
    @IBOutlet private weak var usernameContainerView: UIView!
    @IBOutlet private weak var passwordContainerView: UIView!
    public private(set) weak var usernameTextField: UITextField!
    public private(set) weak var passwordTextField: UITextField!

    private var textFieldFactory: TextFieldFactory!
    private var tapGestureRecognizerFactory: TapGestureRecognizerFactory!
    private var delegate: RegistrationViewControllerDelegate!
    private var animator: Animator!

    public static func make(
        textFieldFactory: @escaping TextFieldFactory = UITextField.init,
        tapGestureRecognizerFactory: @escaping TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        animator: Animator,
        delegate: RegistrationViewControllerDelegate
    ) -> RegistrationViewController {
        let storyboard = UIStoryboard(
            name: "RegistrationViewController",
            bundle: .init(for: RegistrationViewController.self)
        )
        let vc = storyboard.instantiateInitialViewController() as! RegistrationViewController

        vc.textFieldFactory = textFieldFactory
        vc.tapGestureRecognizerFactory = tapGestureRecognizerFactory
        vc.delegate = delegate
        vc.animator = animator

        return vc
    }

    public override func loadView() {
        super.loadView()

        let usernameTextField = makeUsernameTextField()
        let passwordTextField = makePasswordTextField()

        usernameContainerView.addSubview(usernameTextField)
        usernameContainerView.alignInsideSuperview()
        passwordContainerView.addSubview(passwordTextField)
        passwordContainerView.alignInsideSuperview()

        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField

        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelButtonTapped))

        view.addGestureRecognizer(cancelInputTapRecognizer)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        delegate?.onViewDidLoad()
        notifyTextFieldUpdated()
    }

    private func makeUsernameTextField() -> UITextField {
        let textField = textFieldFactory()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = .next

        return textField
    }

    private func makePasswordTextField() -> UITextField {
        let textField = textFieldFactory()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done

        return textField
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        notifyTextFieldUpdated()
    }

    private func notifyTextFieldUpdated() {
        delegate?.didUpdate(username: usernameTextField.text, password: passwordTextField.text)
    }

    @IBAction
    private func onRegisterButtonTapped() {
        delegate?.onRegisterButtonTapped()
    }

    @IBAction
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

extension RegistrationViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
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
    }
}

extension RegistrationViewController: TitleView {
    public func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}

extension RegistrationViewController: RegistrationView {
    public func display(viewModel: RegistrationViewModel) {
        usernameTextField.inputAccessoryView = makeToolbar(items: [
            UIBarButtonItem(title: viewModel.cancelTitle, style: .plain, target: self, action: #selector(onCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: viewModel.nextTitle, style: .plain, target: self, action: #selector(onUsernameNextButtonTapped)),
        ])

        passwordTextField.inputAccessoryView = makeToolbar(items: [
            UIBarButtonItem(title: viewModel.cancelTitle, style: .plain, target: self, action: #selector(onCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: viewModel.doneTitle, style: .plain, target: self, action: #selector(onPasswordDoneButtonTapped)),
        ])
    }

    private func makeToolbar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }

    @objc
    private func onCancelButtonTapped() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc
    private func onUsernameNextButtonTapped() {
        usernameTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }

    @objc
    private func onPasswordDoneButtonTapped() {
        passwordTextField.resignFirstResponder()
        onRegisterButtonTapped()
    }
}

extension RegistrationViewController: ErrorView {
    public func display(viewModel: ErrorViewModel) {
        if let message = viewModel.message {
            showErrorView(message: message)
        } else {
            hideErrorView()
        }
    }
}

private extension UIView {
    func alignInsideSuperview() {
        guard let superview = superview else { return }

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}
