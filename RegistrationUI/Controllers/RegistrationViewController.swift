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
    func didCancelInput()
}

public final class RegistrationViewController: UIViewController {
    public typealias TapGestureRecognizerFactory = (_ target: Any?, _ action: Selector?) -> UITapGestureRecognizer

    private var tapGestureRecognizerFactory: TapGestureRecognizerFactory!
    private var delegate: RegistrationViewControllerDelegate!

    private var formViewController: UIViewController!
    private var errorViewController: UIViewController!
    private var buttonViewController: UIViewController!
    public private(set) var registerWithAppleButton: UIButton = .init()
    public var registerWithApple: () -> () = {}

    public static func make(
        tapGestureRecognizerFactory: @escaping TapGestureRecognizerFactory = UITapGestureRecognizer.init,
        delegate: RegistrationViewControllerDelegate,
        formViewController: UIViewController,
        errorViewController: UIViewController,
        buttonViewController: UIViewController
    ) -> RegistrationViewController {
        let vc = RegistrationViewController()

        vc.tapGestureRecognizerFactory = tapGestureRecognizerFactory
        vc.delegate = delegate
        vc.formViewController = formViewController
        vc.errorViewController = errorViewController
        vc.buttonViewController = buttonViewController

        return vc
    }

    public override func loadView() {
        super.loadView()

        let controllers: [UIViewController] = [
            formViewController!,
            buttonViewController!,
            errorViewController!,
        ]

        controllers.forEach(addChild)

        RegistrationViewLayout(
            container: view,
            form: formViewController.view,
            button: buttonViewController.view,
            error: errorViewController.view
        ).apply()

        controllers.forEach({ $0.didMove(toParent: self) })

        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelInputRecongnizerRecognized))

        view.addGestureRecognizer(cancelInputTapRecognizer)
        view.backgroundColor = UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? .black : .white
        })

        registerWithAppleButton.addTarget(self, action: #selector(onSignInWithAppleButtonTapped), for: .touchUpInside)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        delegate?.onViewDidLoad()
    }

    @objc
    private func onCancelInputRecongnizerRecognized() {
        delegate?.didCancelInput()
    }

    @objc
    private func onSignInWithAppleButtonTapped() {
        registerWithApple()
    }
}

extension RegistrationViewController: TitleView {
    public func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}