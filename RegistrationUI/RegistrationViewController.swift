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

        addButtonViewController()
        addFormViewController()
        addErrorViewController()

        let cancelInputTapRecognizer = tapGestureRecognizerFactory(self, #selector(onCancelInputRecongnizerRecognized))

        view.addGestureRecognizer(cancelInputTapRecognizer)
        view.backgroundColor = UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? .black : .white
        })
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

extension RegistrationViewController: TitleView {
    public func display(viewModel: TitleViewModel) {
        title = viewModel.title
    }
}
