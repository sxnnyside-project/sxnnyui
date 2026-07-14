//
//  Collection.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

// MARK: - Collection Utilities

extension Collection {

    // MARK: Safe Indexing

    /// Returns the element at the specified index if it is within bounds; otherwise, `nil`.
    ///
    /// A safe alternative to direct subscripting, avoiding an out-of-range trap when an
    /// index is derived from something that can drift out of sync with the collection —
    /// for example, a `selection` index held in `@State` after the underlying data reloads.
    ///
    /// ```swift
    /// if let item = items[safe: selectedIndex] {
    ///     Text(item.title)
    /// }
    /// ```
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at `index` if it is valid; otherwise, `nil`.
    @inlinable
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    // MARK: Compaction

    /// Returns a new array containing the non-`nil` elements of the collection.
    ///
    /// A named counterpart to `compactMap { $0 }` for the common case of unwrapping a
    /// collection of optionals without a transform.
    ///
    /// ```swift
    /// let urls: [URL?] = images.map(\.remoteURL)
    /// let validURLs = urls.compacted() // [URL]
    /// ```
    ///
    /// - Returns: An array of unwrapped elements.
    @inlinable
    public func compacted<T>() -> [T] where Element == T? {
        compactMap { $0 }
    }

    // MARK: Emptiness Checks

    /// A Boolean value indicating whether the collection is not empty.
    ///
    /// The inverse of `isEmpty`, provided to avoid double-negative conditions
    /// (`!results.isEmpty`) at call sites such as `if results.isNotEmpty { ... }`.
    @inlinable
    public var isNotEmpty: Bool {
        !isEmpty
    }

    // MARK: Grouping

    /// Groups the elements of the collection into a dictionary keyed by the result of a
    /// given closure.
    ///
    /// A named, discoverable wrapper over `Dictionary(grouping:by:)` that reads naturally
    /// as a modifier chain.
    ///
    /// ```swift
    /// let byCategory = products.grouped(by: \.category)
    /// // [Category: [Product]]
    /// ```
    ///
    /// - Parameter keyForValue: A closure that maps an element to a `Hashable` key.
    /// - Returns: A dictionary where each key maps to an array of the elements that
    ///   produced that key.
    @inlinable
    public func grouped<Key: Hashable>(by keyForValue: (Element) -> Key) -> [Key: [Element]] {
        Dictionary(grouping: self, by: keyForValue)
    }

    // MARK: Chunking

    /// Splits the collection into consecutive chunks of at most the given size.
    ///
    /// Common for laying out data in a fixed-column grid without `LazyVGrid`, or for
    /// batching network requests.
    ///
    /// ```swift
    /// let rows = items.chunked(into: 3)
    /// ForEach(rows.indices, id: \.self) { row in
    ///     HStack { ForEach(rows[row]) { CardView($0) } }
    /// }
    /// ```
    ///
    /// - Parameter size: The maximum size of each chunk. If `size <= 0`, an empty array is
    ///   returned.
    /// - Returns: An array of arrays, each containing up to `size` elements from the
    ///   collection, in order.
    @inlinable
    public func chunked(into size: Int) -> [[Element]] {
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
