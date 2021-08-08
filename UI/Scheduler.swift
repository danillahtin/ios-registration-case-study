//
//  Scheduler.swift
//  Composition
//
//  Created by Danil Lahtin on 08.08.2021.
//

import UIKit

public protocol Scheduler {
    func schedule(_ work: @escaping () -> ())
}

extension DispatchQueue: Scheduler {
    public func schedule(_ work: @escaping () -> ()) {
        async(execute: work)
    }
}

public struct AnimationScheduler: Scheduler {
    private let duration: TimeInterval

    public static let fast: AnimationScheduler = .init(duration: 0.16)

    private init(duration: TimeInterval) {
        self.duration = duration
    }

    public func schedule(_ work: @escaping () -> ()) {
        UIView.animate(withDuration: duration, animations: work)
    }
}
