//
//  UIBarButtonItem+Helpers.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import UIKit

extension UIBarButtonItem {
    func simulateTap() {
        (target as! NSObject).perform(action!)
    }
}
