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

public final class FormViewLayout {
    private let container: UIView
    private let form: UIView
    private let error: UIView
    private let button: UIView

    init(
        container: UIView,
        form: UIView,
        error: UIView,
        button: UIView
    ) {
        self.container = container
        self.form = form
        self.error = error
        self.button = button
    }

    func apply() {
        form.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(form)
        container.addSubview(button)
        container.addSubview(error)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: button.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: button.rightAnchor),
            container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 44),
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: form.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: form.rightAnchor),
            container.safeAreaLayoutGuide.topAnchor.constraint(equalTo: form.topAnchor, constant: -16),
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: error.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: error.rightAnchor),
            container.safeAreaLayoutGuide.topAnchor.constraint(equalTo: error.topAnchor, constant: -40),
        ])
    }
}

public final class RegistrationViewController: UIViewController {
    public typealias TapGestureRecognizerFactory = (_ target: Any?, _ action: Selector?) -> UITapGestureRecognizer

    private var tapGestureRecognizerFactory: TapGestureRecognizerFactory!
    private var delegate: RegistrationViewControllerDelegate!

    private var formViewController: UIViewController!
    private var errorViewController: UIViewController!
    private var buttonViewController: UIViewController!

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

        let controllers = [
            formViewController!,
            errorViewController!,
            buttonViewController!,
        ]

        controllers.forEach(addChild)

        FormViewLayout(
            container: view,
            form: formViewController.view,
            error: errorViewController.view,
            button: buttonViewController.view
        ).apply()

        controllers.forEach({ $0.didMove(toParent: self) })

        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelInputRecongnizerRecognized))

        view.addGestureRecognizer(cancelInputTapRecognizer)
        view.backgroundColor = UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? .black : .white
        })
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

extension RegistrationViewController: TitleView {
    public func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}
