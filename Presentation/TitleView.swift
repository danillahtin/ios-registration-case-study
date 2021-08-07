//
//  TitleView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct TitleViewModel {
    public let title: String
}

public protocol TitleView {
    func display(viewModel: TitleViewModel)
}
