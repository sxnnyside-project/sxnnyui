//
//  CollectionExtensionsTests.swift
//  SxnnyErgoTests
//

import Testing

@testable import SxnnyErgo

@Suite("Collection safe subscript, compaction, emptiness, grouping, chunking")
struct CollectionExtensionsTests {

    // MARK: subscript(safe:)

    @Test("returns the element for an in-bounds index")
    func safeSubscriptInBounds() {
        let array = [10, 20, 30]
        #expect(array[safe: 1] == 20)
    }

    @Test("returns nil for an out-of-bounds index", arguments: [-1, 3, 100])
    func safeSubscriptOutOfBounds(index: Int) {
        let array = [10, 20, 30]
        #expect(array[safe: index] == nil)
    }

    @Test("returns nil for any index on an empty array")
    func safeSubscriptEmpty() {
        let array: [Int] = []
        #expect(array[safe: 0] == nil)
    }

    // MARK: compacted()

    @Test("removes nil elements while preserving order")
    func compactedRemovesNils() {
        let input: [Int?] = [1, nil, 2, nil, 3]
        #expect(input.compacted() == [1, 2, 3])
    }

    @Test("compacting an all-nil array yields an empty array")
    func compactedAllNil() {
        let input: [Int?] = [nil, nil, nil]
        #expect(input.compacted().isEmpty)
    }

    // MARK: isNotEmpty

    @Test("isNotEmpty is the exact inverse of isEmpty")
    func isNotEmptyInverse() {
        #expect([1].isNotEmpty)
        #expect(![Int]().isNotEmpty)
    }

    // MARK: grouped(by:)

    @Test("groups elements by the projected key")
    func groupedByKey() {
        let words = ["apple", "avocado", "banana", "blueberry", "cherry"]
        let grouped = words.grouped(by: { $0.first! })

        #expect(grouped["a"] == ["apple", "avocado"])
        #expect(grouped["b"] == ["banana", "blueberry"])
        #expect(grouped["c"] == ["cherry"])
        #expect(grouped.count == 3)
    }

    // MARK: chunked(into:)

    @Test("splits into chunks of the requested size, with a smaller final chunk")
    func chunkedRegular() {
        let numbers = Array(1...7)
        #expect(numbers.chunked(into: 3) == [[1, 2, 3], [4, 5, 6], [7]])
    }

    @Test("returns a single chunk when size exceeds the collection's count")
    func chunkedLargerThanCollection() {
        let numbers = [1, 2, 3]
        #expect(numbers.chunked(into: 10) == [[1, 2, 3]])
    }

    @Test("returns an empty array for a non-positive size", arguments: [0, -1, -100])
    func chunkedNonPositiveSize(size: Int) {
        let numbers = [1, 2, 3]
        #expect(numbers.chunked(into: size).isEmpty)
    }

    @Test("chunking an empty collection yields an empty array")
    func chunkedEmptyCollection() {
        let numbers: [Int] = []
        #expect(numbers.chunked(into: 3).isEmpty)
    }
}
