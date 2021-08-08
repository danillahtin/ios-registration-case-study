//
//  LoadingView.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

public struct LoadingViewModel: Equatable {
    public let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}

public protocol LoadingView {
    func display(viewModel: LoadingViewModel)
}
