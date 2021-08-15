//
//  SceneDelegate.swift
//  Demo
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit
import RegistrationCore
import RegistrationComposition

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let nc = UINavigationController()
        nc.navigationBar.prefersLargeTitles = true

        let alertPresenter = AlertPresenter(presentingViewController: nc)

        let vc = RegistrationUIKitViewComposer.composed(
            registrationService: DemoRegistrationService(),
            registerWithAppleService: alertPresenter,
            serviceScheduler: DispatchQueue.global(qos: .userInitiated),
            onRegister: { alertPresenter.showAlert(message: "You registered!") }
        )

        nc.viewControllers = [vc]

        window = UIWindow(windowScene: scene)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }
}

struct AlertPresenter: RegisterWithAppleService {
    let presentingViewController: UIViewController

    func showAlert(message: String) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { self.showAlert(message: message) }
        }

        let alertVc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVc.addAction(.init(title: "Ok", style: .default, handler: nil))

        presentingViewController.present(alertVc, animated: true, completion: nil)
    }

    func register() {
        showAlert(message: "Registered with apple")
    }
}

private final class DemoRegistrationService: RegistrationService {
    private var callCount = 0

    func register(with request: RegistrationRequest) -> Result<Void, Error> {
        sleep(3)
        callCount += 1

        if callCount % 2 == 0 {
            return .success(())
        }

        return .failure(
            NSError(
                domain: "Some",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "This is a demo multiline error to demostrate view"
                ]
            )
        )
    }
}
