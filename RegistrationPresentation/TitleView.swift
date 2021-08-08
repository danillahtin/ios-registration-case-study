//
//  TitleView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct TitleViewModel: Equatable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}

public protocol TitleView {
    func display(viewModel: TitleViewModel)
}
