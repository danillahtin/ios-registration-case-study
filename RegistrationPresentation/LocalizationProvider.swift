//
//  LocalizationProvider.swift
//  Presentation
//
//  Created by Danil Lahtin on 08.08.2021.
//

import Foundation

public protocol LocalizationProvider {
    func string(for key: String) -> String
}

public final class DefaultLocalizationProvider: LocalizationProvider {
    public init() {}
    
    public func string(for key: String) -> String {
        NSLocalizedString(
            key,
            tableName: "Localized",
            bundle: Bundle(for: DefaultLocalizationProvider.self),
            comment: ""
        )
    }
}
