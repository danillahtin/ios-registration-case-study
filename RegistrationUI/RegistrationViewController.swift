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

public protocol Layout {
    func apply()
}

public final class ErrorViewLayout: Layout {
    private let container: UIView
    private let error: UIView

    public init(
        container: UIView,
        error: UIView
    ) {
        self.container = container
        self.error = error
    }

    public func apply() {
        error.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(error)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: error.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: error.rightAnchor),
            container.safeAreaLayoutGuide.topAnchor.constraint(equalTo: error.topAnchor, constant: -40),
        ])
    }
}

public final class BottomButtonLayout: Layout {
    private let container: UIView
    private let button: UIView

    public init(
        container: UIView,
        button: UIView
    ) {
        self.container = container
        self.button = button
    }

    public func apply() {
        button.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(button)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: button.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: button.rightAnchor),
            container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 44),
        ])
    }
}

public final class FormViewLayout: Layout {
    private let container: UIView
    private let form: UIView

    public init(
        container: UIView,
        form: UIView
    ) {
        self.container = container
        self.form = form
    }

    public func apply() {
        form.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(form)

        NSLayoutConstraint.activate([
            container.layoutMarginsGuide.leftAnchor.constraint(equalTo: form.leftAnchor),
            container.layoutMarginsGuide.rightAnchor.constraint(equalTo: form.rightAnchor),
            container.safeAreaLayoutGuide.topAnchor.constraint(equalTo: form.topAnchor, constant: -16),
        ])
    }
}

final class LayoutComposite: Layout {
    private let components: [Layout]

    init(components: [Layout]) {
        self.components = components
    }

    public func apply() {
        components.forEach({ $0.apply() })
    }
}

public func RegistrationViewLayout(
    container: UIView,
    form: UIView,
    button: UIView,
    error: UIView
) -> Layout {
    LayoutComposite(components: [
        FormViewLayout(container: container, form: form),
        BottomButtonLayout(container: container, button: button),
        ErrorViewLayout(container: container, error: error),
    ])
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
