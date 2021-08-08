//
//  SceneDelegate.swift
//  Demo
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit
import Core
import Composition

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let nc = UINavigationController()
        nc.navigationBar.prefersLargeTitles = true

        let vc = RegistrationViewComposer.composed(
            registrationService: DemoRegistrationService(),
            serviceScheduler: DispatchQueue.global(qos: .userInitiated),
            onRegister: {
                DispatchQueue.main.async {
                    self.showAlert(message: "You registered!", from: nc)
                }
            },
            onError: { _ in }
        )

        nc.viewControllers = [vc]

        window = UIWindow(windowScene: scene)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }

    private func showAlert(message: String, from vc: UIViewController) {
        let alertVc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVc.addAction(.init(title: "Ok", style: .default, handler: nil))

        vc.present(alertVc, animated: true, completion: nil)
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
