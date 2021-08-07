//
//  Weak.swift
//  Composition
//
//  Created by Danil Lahtin on 08.08.2021.
//

final class Weak<Object: AnyObject> {
    weak var object: Object?

    init(_ object: Object? = nil) {
        self.object = object
    }
}
