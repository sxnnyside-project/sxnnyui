//
//  Binding.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 14/08/25.
//

import SwiftUI

// MARK: - Int <-> Double Conversion

extension Binding where Value == Int {
    /// A `Binding<Double>` view over an `Int` binding.
    ///
    /// Reading converts the integer to a double. Writing converts the double back to an
    /// integer using `Int(_:)`, which truncates toward zero. Useful for driving a `Slider`
    /// (which requires `Binding<Double>`) from state that is naturally an `Int`.
    ///
    /// ```swift
    /// @State private var quantity = 3
    ///
    /// Slider(value: $quantity.double, in: 1...10)
    /// ```
    ///
    /// - Important: Fractional values are truncated when written back to the `Int`.
    @MainActor
    public var double: Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) }
        )
    }
}

extension Binding where Value == Double {
    /// A `Binding<Int>` view over a `Double` binding.
    ///
    /// Reading converts the double to an integer using `Int(_:)` (truncates toward zero).
    /// Writing converts the integer back to a double.
    ///
    /// - Important: Fractional precision is lost when converting to an `Int`.
    @MainActor
    public var int: Binding<Int> {
        Binding<Int>(
            get: { Int(self.wrappedValue) },
            set: { self.wrappedValue = Double($0) }
        )
    }
}

// MARK: - Clamped Binding

extension Binding where Value: Comparable & Sendable {
    /// Returns a new binding that clamps incoming values to the specified closed range.
    ///
    /// Assignments outside the range are clamped to the nearest bound before being written
    /// through to the underlying storage. Reading is unaffected.
    ///
    /// ```swift
    /// @State private var volume = 50.0
    ///
    /// Slider(value: $volume.clamped(to: 0...100))
    /// ```
    ///
    /// - Parameter limits: The allowed closed range for the value.
    /// - Returns: A binding that enforces the provided range on write.
    @MainActor
    public func clamped(to limits: ClosedRange<Value>) -> Binding<Value> {
        Binding<Value>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = Swift.min(Swift.max($0, limits.lowerBound), limits.upperBound) }
        )
    }
}

// MARK: - Optional Binding with Default

extension Binding {
    /// Returns a non-optional binding by substituting a default value when the wrapped
    /// optional is `nil`.
    ///
    /// Reading yields the wrapped value or the provided default. Writing assigns the new
    /// value back into the optional (replacing `nil`). This is the common bridge between
    /// `Binding<T?>` state and a control that requires `Binding<T>` (such as a segmented
    /// `Picker` or a non-optional `TextField`).
    ///
    /// ```swift
    /// @State private var nickname: String? = nil
    ///
    /// TextField("Nickname", text: $nickname.replacingNil(with: ""))
    /// ```
    ///
    /// - Parameter defaultValue: The value substituted when `self` is `nil`.
    /// - Returns: A `Binding<T>` that projects a non-optional view over an optional binding.
    @MainActor
    public func replacingNil<T: Sendable>(with defaultValue: T) -> Binding<T>
    where Value == T? {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

// MARK: - Boolean Toggle from Comparable

extension Binding where Value: Comparable & Sendable {
    /// Returns a `Binding<Bool>` that is `true` when the wrapped value equals the target.
    ///
    /// Useful for driving a `Toggle` or conditional styling from a single selected value
    /// held elsewhere in state, without introducing a separate `Bool` property to keep
    /// in sync by hand.
    ///
    /// ```swift
    /// @State private var selection: Tab = .home
    ///
    /// Toggle("Home selected", isOn: $selection.isEqual(to: .home))
    /// ```
    ///
    /// - Parameter target: The value to compare against.
    /// - Returns: A boolean binding reflecting equality. Writing `true` sets the wrapped
    ///   value to `target`; writing `false` is a no-op, since there is no single value that
    ///   correctly represents "not equal to `target`."
    @MainActor
    public func isEqual(to target: Value) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue == target },
            set: { isTarget in
                if isTarget {
                    self.wrappedValue = target
                }
            }
        )
    }
}

// MARK: - Identifiable Element Binding

extension Binding {
    /// Returns a `Binding` scoped to the element with the given `id`, or `nil` if no element
    /// with that `id` currently exists in the array.
    ///
    /// - Design note: This returns `Binding<Element>?` rather than a non-optional `Binding<Element>`
    ///   because the id genuinely may not be present — for example, if the array is mutated
    ///   elsewhere between the time a `ForEach` row is created and the time this binding is
    ///   evaluated. A non-optional signature would have to invent a placeholder value on miss,
    ///   which is dishonest about the failure mode and risks silently editing the wrong element.
    ///   Callers that need a non-optional `Binding<Element>` to hand to a subview (e.g. inside a
    ///   `ForEach(array) { element in ... }` row, where SwiftUI has already guaranteed the element
    ///   exists for that render pass) should use ``binding(forID:default:)`` instead, mirroring how
    ///   `List(selection:)` accepts an optional selection while `ForEach` hands rows a concrete value.
    ///
    /// The returned binding is safe at write time: if the element has been removed from the array
    /// by the time a write occurs, the write silently no-ops instead of trapping or corrupting a
    /// different element.
    ///
    /// - Parameter id: The `id` of the element to project a binding for.
    /// - Returns: A `Binding<Element>` for the matching element, or `nil` if none is found.
    @MainActor
    public func binding<Element: Identifiable>(forID id: Element.ID) -> Binding<Element>?
    where Value == [Element] {
        guard let snapshot = wrappedValue.first(where: { $0.id == id }) else { return nil }
        return Binding<Element>(
            get: { self.wrappedValue.first(where: { $0.id == id }) ?? snapshot },
            set: { newValue in
                guard let index = self.wrappedValue.firstIndex(where: { $0.id == id }) else { return }
                self.wrappedValue[index] = newValue
            }
        )
    }

    /// Returns a non-optional `Binding` scoped to the element with the given `id`, falling back to
    /// `defaultValue` for reads if the element is not present.
    ///
    /// Use this variant when you already know (from the calling context, e.g. a `ForEach` row) that
    /// the element exists and you need a concrete `Binding<Element>` to pass to a subview initializer.
    /// Writes are still safe if the element disappears in the meantime: the write silently no-ops
    /// rather than corrupting another element or trapping.
    ///
    /// - Parameters:
    ///   - id: The `id` of the element to project a binding for.
    ///   - defaultValue: The value to read if no element with `id` currently exists.
    /// - Returns: A `Binding<Element>` that reads `defaultValue` on miss and no-ops on write on miss.
    @MainActor
    public func binding<Element: Identifiable>(forID id: Element.ID, default defaultValue: Element) -> Binding<Element>
    where Value == [Element] {
        Binding<Element>(
            get: { self.wrappedValue.first(where: { $0.id == id }) ?? defaultValue },
            set: { newValue in
                guard let index = self.wrappedValue.firstIndex(where: { $0.id == id }) else { return }
                self.wrappedValue[index] = newValue
            }
        )
    }
}

// MARK: - Dictionary Key Binding

extension Binding {
    /// Returns a `Binding<Val>` scoped to a single key of the wrapped dictionary.
    ///
    /// Reading yields the value for `key`, or `defaultValue` if the key is absent. Writing sets
    /// `key` to the new value, inserting it if it was previously absent. This binding is always
    /// valid — there is no missing-key failure mode to reason about, unlike element-by-id bindings
    /// over an array.
    ///
    /// - Parameters:
    ///   - key: The dictionary key to project a binding for.
    ///   - defaultValue: The value to use when `key` is absent, both for reads and as the basis
    ///     for the first write.
    /// - Returns: A `Binding<Val>` scoped to `key`.
    @MainActor
    public func binding<Key: Hashable, Val>(forKey key: Key, default defaultValue: Val) -> Binding<Val>
    where Value == [Key: Val] {
        Binding<Val>(
            get: { self.wrappedValue[key] ?? defaultValue },
            set: { self.wrappedValue[key] = $0 }
        )
    }
}

// MARK: - Set Membership Binding

extension Binding {
    /// Returns a `Binding<Bool>` representing whether `member` is contained in the wrapped set.
    ///
    /// Reading returns `true` if `member` is currently in the set. Writing `true` inserts `member`
    /// into the set; writing `false` removes it. This mirrors the ``isEqual(to:)`` pattern above:
    /// both derive a `Binding<Bool>` from a richer binding, projecting a single boolean facet of a
    /// larger value.
    ///
    /// - Parameter member: The element whose membership is projected.
    /// - Returns: A `Binding<Bool>` reflecting and controlling `member`'s membership in the set.
    @MainActor
    public func contains<Element: Hashable>(_ member: Element) -> Binding<Bool>
    where Value == Set<Element> {
        Binding<Bool>(
            get: { self.wrappedValue.contains(member) },
            set: { isMember in
                if isMember {
                    self.wrappedValue.insert(member)
                } else {
                    self.wrappedValue.remove(member)
                }
            }
        )
    }
}
