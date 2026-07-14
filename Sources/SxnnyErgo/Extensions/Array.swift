//
//  Array.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 23/05/25.
//

// MARK: - Array Utilities

/// Convenience utilities for `Array`.
extension Array {

    // MARK: Deduplication

    /// Returns a new array with duplicates removed, using a key path as the uniqueness criterion.
    ///
    /// Order is preserved: the first occurrence of each key is kept, and every subsequent
    /// element with the same key is discarded. This is the SwiftUI-adjacent case native
    /// `Set`-based deduplication cannot express, since `Element` itself need not be `Hashable` —
    /// only the projected key must be.
    ///
    /// ```swift
    /// struct Contact: Identifiable { let id: UUID; let email: String }
    ///
    /// let deduplicated = contacts.unique(by: \.email)
    /// ForEach(deduplicated) { contact in
    ///     Text(contact.email)
    /// }
    /// ```
    ///
    /// - Parameter keyPath: A key path to a `Hashable` value that determines uniqueness.
    /// - Returns: A new array containing only the first occurrence of each unique key.
    @inlinable
    public func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
