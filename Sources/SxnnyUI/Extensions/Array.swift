//
//  Array.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

// MARK: - Array Utilities

/// Convenience utilities for `Array`.
///
/// These extensions provide:
/// - Safe random access (returns `nil` for empty arrays)
/// - Deduplication by a key path (keeps the first occurrence)
public extension Array {

    // MARK: Safe Random Element

    /// Returns a random element if the array is not empty; otherwise, `nil`.
    ///
    /// This avoids calling `randomElement()` on an empty array, which returns `nil`,
    /// by making the intent explicit at the call site.
    @inlinable
    var safeRandomElement: Element? {
        isEmpty ? nil : randomElement()
    }

    // MARK: Deduplication

    /// Returns a new array with duplicates removed, using a key path as the uniqueness criterion.
    ///
    /// - Important: This method preserves the order of the first occurrences. Subsequent elements
    ///   with the same key are discarded.
    ///
    /// - Parameter keyPath: A key path to a `Hashable` value that determines uniqueness.
    /// - Returns: A new array containing only the first occurrence of each unique key.
    @inlinable
    func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
