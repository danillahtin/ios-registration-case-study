//
//  Scheduler.swift
//  Composition
//
//  Created by Danil Lahtin on 08.08.2021.
//

import Foundation

public protocol Scheduler {
    func schedule(_ work: @escaping () -> ())
}

extension DispatchQueue: Scheduler {
    public func schedule(_ work: @escaping () -> ()) {
        async(execute: work)
    }
}
