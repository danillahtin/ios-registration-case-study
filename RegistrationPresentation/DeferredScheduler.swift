//
//  DeferredScheduler.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public protocol DeferredScheduler {
    func schedule(after: TimeInterval, _ work: @escaping () -> ()) -> Cancellable
}
