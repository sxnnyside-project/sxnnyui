//
//  If.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 31/03/25.
//

import SwiftUI

// MARK: - Conditional View Helpers
//
// All overloads below build on `@ViewBuilder`/`Group`, which preserves each branch's
// structural view identity. None of them use `AnyView`, so applying a condition never
// forces a type-erasure performance cost, even when the two branches produce different
// concrete view types.

extension View {

    // MARK: Boolean Conditions

    /// Conditionally applies a transformation when the condition is `true`.
    ///
    /// ```swift
    /// Text("Overdue")
    ///     .if(isPastDue) { $0.foregroundStyle(.red) }
    /// ```
    ///
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: A transformation applied to `self` when `condition` is `true`.
    /// - Returns: `transform(self)` if `condition` is `true`; otherwise `self`, unmodified.
    @inlinable
    public func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        Group {
            if condition {
                transform(self)
            } else {
                self
            }
        }
    }

    /// Conditionally applies one of two transformations depending on a Boolean condition.
    ///
    /// ```swift
    /// icon
    ///     .ifElse(isSelected, then: { $0.foregroundStyle(.accent) }, else: { $0.foregroundStyle(.secondary) })
    /// ```
    ///
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - thenTransform: Applied when `condition` is `true`.
    ///   - elseTransform: Applied when `condition` is `false`.
    /// - Returns: `thenTransform(self)` if `condition` is `true`; otherwise `elseTransform(self)`.
    @inlinable
    public func ifElse<ThenTransform: View, ElseTransform: View>(
        _ condition: Bool,
        then thenTransform: (Self) -> ThenTransform,
        else elseTransform: (Self) -> ElseTransform
    ) -> some View {
        Group {
            if condition {
                thenTransform(self)
            } else {
                elseTransform(self)
            }
        }
    }

    // MARK: Optional Conditions

    /// Applies a transformation when the optional value is not `nil`.
    ///
    /// Eliminates the boilerplate of unwrapping a value solely to conditionally style or
    /// wrap a view with it.
    ///
    /// ```swift
    /// Text(user.name)
    ///     .ifLet(user.badgeCount) { view, count in
    ///         view.overlay(alignment: .topTrailing) { Badge(count) }
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - value: An optional value. When non-`nil`, the transformation receives both
    ///     `self` and the unwrapped value.
    ///   - transform: A transformation applied when `value` is non-`nil`.
    /// - Returns: The transformed view when `value` is non-`nil`; otherwise `self`.
    @inlinable
    public func ifLet<T, Transform: View>(_ value: T?, transform: (Self, T) -> Transform) -> some View {
        Group {
            if let value {
                transform(self, value)
            } else {
                self
            }
        }
    }

    /// Applies one of two transformations depending on whether the optional value is `nil`.
    ///
    /// ```swift
    /// content
    ///     .ifLetElse(errorMessage, then: { view, message in
    ///         view.overlay(ErrorBanner(message))
    ///     }, else: { view in
    ///         view
    ///     })
    /// ```
    ///
    /// - Parameters:
    ///   - value: An optional value. When non-`nil`, `thenTransform` is applied with the
    ///     unwrapped value.
    ///   - thenTransform: Applied when `value` is non-`nil`.
    ///   - elseTransform: Applied when `value` is `nil`.
    /// - Returns: The result of `thenTransform(self, value)` when `value` is non-`nil`;
    ///   otherwise `elseTransform(self)`.
    @inlinable
    public func ifLetElse<T, ThenTransform: View, ElseTransform: View>(
        _ value: T?,
        then thenTransform: (Self, T) -> ThenTransform,
        else elseTransform: (Self) -> ElseTransform
    ) -> some View {
        Group {
            if let value {
                thenTransform(self, value)
            } else {
                elseTransform(self)
            }
        }
    }
}
