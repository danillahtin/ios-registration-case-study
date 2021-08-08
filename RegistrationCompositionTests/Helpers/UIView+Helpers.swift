//
//  UIView+Helpers.swift
//  CompositionTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import UIKit

extension UIView {
    var toolbarItems: [UIBarButtonItem]? {
        let toolbar = inputAccessoryView as? UIToolbar
        return toolbar?.items
    }
}

