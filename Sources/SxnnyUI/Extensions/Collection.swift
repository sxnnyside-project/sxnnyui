//
//  Collection.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

// MARK: - Collection Utilities

public extension Collection {

    // MARK: Safe Indexing

    /// Returns the element at the specified index if it is within bounds; otherwise, `nil`.
    ///
    /// This provides a safe alternative to direct subscripting, avoiding out-of-range traps.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at `index` if it is valid; otherwise, `nil`.
    @inlinable
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    // MARK: Compaction

    /// Returns a new array containing the non-`nil` elements of the collection.
    ///
    /// This is a convenience wrapper around `compactMap` for collections of optional elements.
    ///
    /// - Returns: An array of unwrapped elements.
    @inlinable
    func compacted<T>() -> [T] where Element == T? {
        compactMap { $0 }
    }

    // MARK: Emptiness Checks

    /// A Boolean value indicating whether the collection is not empty.
    ///
    /// This is the inverse of `isEmpty` and can improve readability at call sites.
    @inlinable
    var isNotEmpty: Bool {
        !isEmpty
    }

    // MARK: Grouping

    /// Groups the elements of the collection into a dictionary keyed by the result of a given closure.
    ///
    /// - Parameter keyForValue: A closure that maps an element to a `Hashable` key.
    /// - Returns: A dictionary where each key maps to an array of the elements that produced that key.
    @inlinable
    func grouped<Key: Hashable>(by keyForValue: (Element) -> Key) -> [Key: [Element]] {
        Dictionary(grouping: self, by: keyForValue)
    }

    // MARK: Chunking

    /// Splits the collection into consecutive chunks of at most the given size.
    ///
    /// - Parameter size: The maximum size of each chunk. If `size <= 0`, an empty array is returned.
    /// - Returns: An array of arrays, each containing up to `size` elements from the collection, in order.
    @inlinable
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var chunks: [[Element]] = []
        var currentIndex = startIndex

        while currentIndex != endIndex {
            let nextIndex = index(currentIndex, offsetBy: size, limitedBy: endIndex) ?? endIndex
            chunks.append(Array(self[currentIndex..<nextIndex]))
            currentIndex = nextIndex
        }

        return chunks
    }
}
