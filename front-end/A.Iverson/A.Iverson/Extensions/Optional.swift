//
//  Optional.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import Foundation

public extension Collection {
    /// Convenience helper to improve readability when checking for a non-empty collection
    ///
    /// - returns: `true` if the collection has contents.
    var isNotEmpty: Bool {
        !isEmpty
    }
}

public extension Optional where Wrapped: Collection {
    /// - returns: `true` if the collection is empty or nil
    var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }

    /// - returns: `true` if the collection is non-nil AND has contents.
    var isNotEmpty: Bool {
        self?.isNotEmpty ?? false
    }
}
