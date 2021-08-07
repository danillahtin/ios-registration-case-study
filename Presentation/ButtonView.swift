//
//  ButtonView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct ButtonViewModel: Equatable {
    public let title: String?
    public let isEnabled: Bool

    public init(title: String?, isEnabled: Bool) {
        self.title = title
        self.isEnabled = isEnabled
    }
}

public protocol ButtonView {
    func display(viewModel: ButtonViewModel)
}
