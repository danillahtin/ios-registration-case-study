//
//  Layout.swift
//  RegistrationUI
//
//  Created by Danil Lahtin on 10.08.2021.
//

public protocol Layout {
    func apply()
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
