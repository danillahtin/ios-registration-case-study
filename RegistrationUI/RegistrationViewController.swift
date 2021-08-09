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

public final class ButtonViewController: UIViewController {
    public private(set) weak var button: UIButton!
    public private(set) weak var activityIndicator: UIActivityIndicatorView!

    public var onButtonTappedBlock: (() -> ())?

    public static func make() -> ButtonViewController {
        ButtonViewController()
    }
    
    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemIndigo

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white

        view.addSubview(button)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.leftAnchor),
            button.rightAnchor.constraint(equalTo: view.rightAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        self.button = button
        self.activityIndicator = activityIndicator
        self.view = view
    }

    @objc
    private func onButtonTapped() {
        onButtonTappedBlock?()
    }
}

extension ButtonViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
            button.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            button.isHidden = false
        }
    }
}

extension ButtonViewController: ButtonView {
    public func display(viewModel: ButtonViewModel) {
        button.setTitle(viewModel.title, for: .normal)
        button.isEnabled = viewModel.isEnabled
        view.backgroundColor = viewModel.isEnabled
            ? view.backgroundColor?.withAlphaComponent(1)
            : view.backgroundColor?.withAlphaComponent(0.4)
    }
}

public final class RegistrationViewController: UIViewController {
    public typealias TapGestureRecognizerFactory = (_ target: Any?, _ action: Selector?) -> UITapGestureRecognizer

    private var tapGestureRecognizerFactory: TapGestureRecognizerFactory!
    private var delegate: RegistrationViewControllerDelegate!

    private var formViewController: UIViewController!
    private var errorViewController: UIViewController!
    private var buttonViewController: ButtonViewController!

    public static func make(
        tapGestureRecognizerFactory: @escaping TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        delegate: RegistrationViewControllerDelegate,
        formViewController: UIViewController,
        errorViewController: UIViewController
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

        let buttonViewController = ButtonViewController.make()
        buttonViewController.onButtonTappedBlock = delegate.onRegisterButtonTapped

        vc.buttonViewController = buttonViewController


        return vc
    }

    public override func loadView() {
        super.loadView()

        addButtonViewController()
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

    private func addButtonViewController() {
        addChild(buttonViewController) {
            [
                view.layoutMarginsGuide.leftAnchor.constraint(equalTo: $0.leftAnchor),
                view.layoutMarginsGuide.rightAnchor.constraint(equalTo: $0.rightAnchor),
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: 44),
            ]
        }
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

    @objc
    private func onCancelInputRecongnizerRecognized() {
        delegate?.didCancelInput()
    }
}

extension RegistrationViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        buttonViewController.display(viewModel: viewModel)
    }
}

extension RegistrationViewController: ButtonView {
    public func display(viewModel: ButtonViewModel) {
        buttonViewController.display(viewModel: viewModel)
    }
}

extension RegistrationViewController: TitleView {
    public func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}
