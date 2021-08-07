//
//  LoadingView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct LoadingViewModel {
    public let isLoading: Bool
}

public protocol LoadingView {
    func display(viewModel: LoadingViewModel)
}
