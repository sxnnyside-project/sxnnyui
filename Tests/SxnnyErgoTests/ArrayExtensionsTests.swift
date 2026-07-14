//
//  ArrayExtensionsTests.swift
//  SxnnyErgoTests
//

import Testing

@testable import SxnnyErgo

@Suite("Array.unique(by:)")
struct ArrayExtensionsTests {

    @Test("keeps the first occurrence of each key, preserving order")
    func keepsFirstOccurrence() {
        struct Item: Equatable {
            let key: Int
            let tag: String
        }
        let items = [
            Item(key: 1, tag: "a"),
            Item(key: 2, tag: "b"),
            Item(key: 1, tag: "c"),
            Item(key: 3, tag: "d"),
            Item(key: 2, tag: "e"),
        ]

        let result = items.unique(by: \.key)

        #expect(
            result == [
                Item(key: 1, tag: "a"),
                Item(key: 2, tag: "b"),
                Item(key: 3, tag: "d"),
            ])
    }

    @Test("returns an empty array for empty input")
    func emptyInput() {
        let items: [Int] = []
        #expect(items.unique(by: \.self).isEmpty)
    }

    @Test("returns the same elements when all keys are already unique")
    func allUnique() {
        let items = [1, 2, 3, 4]
        #expect(items.unique(by: \.self) == items)
    }

    @Test("collapses an array of entirely duplicate keys to a single element")
    func allDuplicates() {
        let items = [7, 7, 7, 7]
        #expect(items.unique(by: \.self) == [7])
    }
}
