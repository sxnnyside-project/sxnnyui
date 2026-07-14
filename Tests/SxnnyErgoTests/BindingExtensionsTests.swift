//
//  BindingExtensionsTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("Binding conversions, clamping, optional defaulting, and equality")
struct BindingExtensionsTests {

    // MARK: Int <-> Double

    @Test("double view reads the current Int as a Double")
    func doubleReadsInt() {
        var value = 5
        let binding = Binding(get: { value }, set: { value = $0 })
        #expect(binding.double.wrappedValue == 5.0)
    }

    @Test("writing through the double view truncates toward zero")
    func doubleWriteTruncates() {
        var value = 0
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.double.wrappedValue = 3.9
        #expect(value == 3)
    }

    @Test("int view reads the current Double as an Int, truncated")
    func intReadsDouble() {
        var value = 2.7
        let binding = Binding(get: { value }, set: { value = $0 })
        #expect(binding.int.wrappedValue == 2)
    }

    @Test("writing through the int view converts back to Double")
    func intWriteConverts() {
        var value = 0.0
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.int.wrappedValue = 9
        #expect(value == 9.0)
    }

    // MARK: clamped(to:)

    @Test("values inside the range pass through unchanged")
    func clampedInsideRange() {
        var value = 50
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.clamped(to: 0...100).wrappedValue = 42
        #expect(value == 42)
    }

    @Test("values above the range clamp to the upper bound")
    func clampedAboveRange() {
        var value = 0
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.clamped(to: 0...100).wrappedValue = 999
        #expect(value == 100)
    }

    @Test("values below the range clamp to the lower bound")
    func clampedBelowRange() {
        var value = 50
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.clamped(to: 0...100).wrappedValue = -999
        #expect(value == 0)
    }

    @Test("a single-value range clamps everything to that value")
    func clampedSingleValueRange() {
        var value = 0
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.clamped(to: 5...5).wrappedValue = 100
        #expect(value == 5)
    }

    // MARK: replacingNil(with:)

    @Test("reading substitutes the default when the wrapped value is nil")
    func replacingNilReadsDefault() {
        var value: String? = nil
        let binding = Binding(get: { value }, set: { value = $0 })
        #expect(binding.replacingNil(with: "fallback").wrappedValue == "fallback")
    }

    @Test("reading returns the wrapped value when non-nil")
    func replacingNilReadsWrapped() {
        var value: String? = "present"
        let binding = Binding(get: { value }, set: { value = $0 })
        #expect(binding.replacingNil(with: "fallback").wrappedValue == "present")
    }

    @Test("writing assigns back into the optional")
    func replacingNilWrites() {
        var value: String? = nil
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.replacingNil(with: "fallback").wrappedValue = "new"
        #expect(value == "new")
    }

    // MARK: isEqual(to:)

    @Test("reads true when the wrapped value equals the target")
    func isEqualReadsTrue() {
        var value = 3
        let binding = Binding(get: { value }, set: { value = $0 })
        #expect(binding.isEqual(to: 3).wrappedValue == true)
    }

    @Test("reads false when the wrapped value differs from the target")
    func isEqualReadsFalse() {
        var value = 3
        let binding = Binding(get: { value }, set: { value = $0 })
        #expect(binding.isEqual(to: 9).wrappedValue == false)
    }

    @Test("writing true sets the wrapped value to the target")
    func isEqualWriteTrue() {
        var value = 0
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.isEqual(to: 7).wrappedValue = true
        #expect(value == 7)
    }

    @Test("writing false is a no-op")
    func isEqualWriteFalseIsNoOp() {
        var value = 5
        let binding = Binding(get: { value }, set: { value = $0 })
        binding.isEqual(to: 7).wrappedValue = false
        #expect(value == 5)
    }

    // MARK: Identifiable Element Binding

    struct Item: Identifiable, Equatable {
        let id: Int
        var name: String
    }

    @Test("binding(forID:) reads the matching element")
    func elementBindingReads() {
        var items = [Item(id: 1, name: "A"), Item(id: 2, name: "B")]
        let binding = Binding(get: { items }, set: { items = $0 })
        #expect(binding.binding(forID: 2)?.wrappedValue.name == "B")
    }

    @Test("binding(forID:) returns nil for a missing id")
    func elementBindingReturnsNilForMissingID() {
        var items = [Item(id: 1, name: "A")]
        let binding = Binding(get: { items }, set: { items = $0 })
        #expect(binding.binding(forID: 99) == nil)
    }

    @Test("binding(forID:) writes back to the correct element")
    func elementBindingWrites() {
        var items = [Item(id: 1, name: "A"), Item(id: 2, name: "B")]
        let binding = Binding(get: { items }, set: { items = $0 })
        binding.binding(forID: 2)?.wrappedValue = Item(id: 2, name: "Updated")
        #expect(items == [Item(id: 1, name: "A"), Item(id: 2, name: "Updated")])
    }

    @Test("binding(forID:) write silently no-ops if the element was removed")
    func elementBindingWriteNoOpsOnMissingElement() {
        var items = [Item(id: 1, name: "A"), Item(id: 2, name: "B")]
        let binding = Binding(get: { items }, set: { items = $0 })
        let element = binding.binding(forID: 2)
        items.removeAll { $0.id == 2 }
        element?.wrappedValue = Item(id: 2, name: "Should not appear")
        #expect(items == [Item(id: 1, name: "A")])
    }

    @Test("binding(forID:default:) falls back to the default on read when missing")
    func elementBindingWithDefaultFallsBackOnRead() {
        var items = [Item(id: 1, name: "A")]
        let binding = Binding(get: { items }, set: { items = $0 })
        let fallback = Item(id: 99, name: "Fallback")
        #expect(binding.binding(forID: 99, default: fallback).wrappedValue == fallback)
    }

    // MARK: Dictionary Key Binding

    @Test("binding(forKey:default:) reads the value for an existing key")
    func dictionaryBindingReadsExistingKey() {
        var scores = ["Alice": 10]
        let binding = Binding(get: { scores }, set: { scores = $0 })
        #expect(binding.binding(forKey: "Alice", default: 0).wrappedValue == 10)
    }

    @Test("binding(forKey:default:) reads the default for a missing key")
    func dictionaryBindingReadsDefaultForMissingKey() {
        var scores: [String: Int] = [:]
        let binding = Binding(get: { scores }, set: { scores = $0 })
        #expect(binding.binding(forKey: "Bob", default: -1).wrappedValue == -1)
    }

    @Test("binding(forKey:default:) writes insert a previously-absent key")
    func dictionaryBindingWritesInsertMissingKey() {
        var scores: [String: Int] = [:]
        let binding = Binding(get: { scores }, set: { scores = $0 })
        binding.binding(forKey: "Carol", default: 0).wrappedValue = 42
        #expect(scores["Carol"] == 42)
    }

    // MARK: Set Membership Binding

    @Test("contains(_:) reads true for a member already in the set")
    func setMembershipReadsTrue() {
        var tags: Set<String> = ["swift", "ios"]
        let binding = Binding(get: { tags }, set: { tags = $0 })
        #expect(binding.contains("swift").wrappedValue == true)
    }

    @Test("contains(_:) reads false for a member not in the set")
    func setMembershipReadsFalse() {
        var tags: Set<String> = ["swift"]
        let binding = Binding(get: { tags }, set: { tags = $0 })
        #expect(binding.contains("android").wrappedValue == false)
    }

    @Test("writing true inserts the member")
    func setMembershipWriteTrueInserts() {
        var tags: Set<String> = []
        let binding = Binding(get: { tags }, set: { tags = $0 })
        binding.contains("swift").wrappedValue = true
        #expect(tags.contains("swift"))
    }

    @Test("writing false removes the member")
    func setMembershipWriteFalseRemoves() {
        var tags: Set<String> = ["swift"]
        let binding = Binding(get: { tags }, set: { tags = $0 })
        binding.contains("swift").wrappedValue = false
        #expect(!tags.contains("swift"))
    }
}
