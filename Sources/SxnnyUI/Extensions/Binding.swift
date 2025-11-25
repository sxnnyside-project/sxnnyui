//
//  Binding.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 14/08/25.
//

import SwiftUI

// MARK: - Int <-> Double Conversion

public extension Binding where Value == Int {
    /// A `Binding<Double>` view over an `Int` binding.
    ///
    /// Reading converts the integer to a double. Writing converts the double to an integer
    /// using `Int(_:)`, which truncates toward zero.
    ///
    /// - Important: Fractional values are truncated when written back to the `Int`.
    var double: Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) }
        )
    }
}

public extension Binding where Value == Double {
    /// A `Binding<Int>` view over a `Double` binding.
    ///
    /// Reading converts the double to an integer using `Int(_:)` (truncates toward zero).
    /// Writing converts the integer to a double.
    ///
    /// - Important: Fractional precision is lost when converting to an `Int`.
    var int: Binding<Int> {
        Binding<Int>(
            get: { Int(self.wrappedValue) },
            set: { self.wrappedValue = Double($0) }
        )
    }
}

// MARK: - Clamped Binding

public extension Binding where Value: Comparable {
    /// Returns a new binding that clamps incoming values to the specified closed range.
    ///
    /// Assignments outside the range are clamped to the nearest bound.
    ///
    /// - Parameter limits: The allowed closed range for the value.
    /// - Returns: A binding that enforces the provided range on write.
    func clamped(to limits: ClosedRange<Value>) -> Binding<Value> {
        Binding<Value>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = Swift.min(Swift.max($0, limits.lowerBound), limits.upperBound) }
        )
    }
}

// MARK: - Optional Binding with Default

public extension Binding {
    /// Returns a non-optional binding by providing a default value when the wrapped optional is `nil`.
    ///
    /// Reading yields the wrapped value or the provided default. Writing assigns the new value
    /// back into the optional (replacing `nil`).
    ///
    /// - Parameter defaultValue: The value to use when the optional is `nil`.
    /// - Returns: A `Binding<T>` that projects a non-optional view over an optional binding.
    func replacingNil<T>(with defaultValue: T) -> Binding<T>
    where Value == Optional<T> {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

// MARK: - Boolean Toggle from Comparable

public extension Binding where Value: Comparable {
    /// Returns a `Binding<Bool>` that is `true` when the wrapped value equals the target.
    ///
    /// - Parameter target: The value to compare against.
    /// - Returns: A boolean binding reflecting equality. Writing `true` sets the wrapped value to `target`;
    ///   writing `false` is a no-op.
    func isEqual(to target: Value) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue == target },
            set: { $0 ? (self.wrappedValue = target) : () }
        )
    }
}
