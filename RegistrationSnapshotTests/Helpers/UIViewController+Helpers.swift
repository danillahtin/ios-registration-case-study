//
//  UIViewController+Helpers.swift
//  RegistrationUITests
//
//  Created by Danil Lahtin on 10.08.2021.
//

import UIKit

extension UIViewController {
    func wrappedInDemoContainer() -> UIViewController {
        let container = UIViewController()
        container.view.backgroundColor = UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? .black : .white
        })
        container.addChild(self)
        container.view.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.view.layoutMarginsGuide.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            container.view.layoutMarginsGuide.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            container.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.view.topAnchor),
        ])

        self.didMove(toParent: container)

        return container
    }

    convenience init(view: UIView) {
        self.init()

        self.view = view
    }
}

