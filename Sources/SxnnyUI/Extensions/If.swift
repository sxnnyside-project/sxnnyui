//
//  If.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 31/03/25.
//

import SwiftUI

// MARK: - Conditional View Helpers

public extension View {

    // MARK: Boolean Conditions (Type-Erased)

    /// Conditionally applies a transformation when the condition evaluates to `true`.
    ///
    /// This overload returns a type-erased `some View` using `AnyView`, which can be
    /// useful when the branches yield different concrete view types.
    ///
    /// - Parameters:
    ///   - condition: An autoclosure that produces the condition to evaluate.
    ///   - apply: A transformation applied to `self` when `condition` is `true`.
    /// - Returns: The transformed view if `condition` is `true`; otherwise, `self`.
    @inlinable
    func `if`(_ condition: @autoclosure () -> Bool, then apply: (Self) -> some View) -> some View {
        if condition() {
            return AnyView(apply(self))
        } else {
            return AnyView(self)
        }
    }

    /// Conditionally applies one of two transformations depending on the boolean condition.
    ///
    /// This overload returns a type-erased `some View` using `AnyView`, which can be
    /// useful when the branches yield different concrete view types.
    ///
    /// - Parameters:
    ///   - condition: An autoclosure that produces the condition to evaluate.
    ///   - ifTransform: A transformation applied when `condition` is `true`.
    ///   - elseTransform: A transformation applied when `condition` is `false`.
    /// - Returns: The result of `ifTransform(self)` if `condition` is `true`; otherwise `elseTransform(self)`.
    @inlinable
    func ifElse(
        _ condition: @autoclosure () -> Bool,
        then ifTransform: (Self) -> some View,
        else elseTransform: (Self) -> some View
    ) -> some View {
        if condition() {
            return AnyView(ifTransform(self))
        } else {
            return AnyView(elseTransform(self))
        }
    }

    // MARK: Boolean Conditions (Generic, Non–Type-Erased)

    /// Conditionally applies a transformation when the condition is `true`.
    ///
    /// This generic overload preserves the concrete view type of the transformation,
    /// which can be preferable for performance and type inference in many cases.
    ///
    /// - Parameters:
    ///   - condition: The boolean condition to evaluate.
    ///   - transform: A transformation applied to `self` when `condition` is `true`.
    /// - Returns: `transform(self)` if `condition` is `true`; otherwise `self`.
    @inlinable
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        Group {
            if condition {
                transform(self)
            } else {
                self
            }
        }
    }

    /// Conditionally applies one of two transformations depending on the boolean condition.
    ///
    /// This generic overload preserves the concrete view types of both branches.
    ///
    /// - Parameters:
    ///   - condition: The boolean condition to evaluate.
    ///   - ifTransform: A transformation applied when `condition` is `true`.
    ///   - elseTransform: A transformation applied when `condition` is `false`.
    /// - Returns: `ifTransform(self)` if `condition` is `true`; otherwise `elseTransform(self)`.
    @inlinable
    func ifElse<TrueTransform: View, FalseTransform: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueTransform,
        else elseTransform: (Self) -> FalseTransform
    ) -> some View {
        Group {
            if condition {
                ifTransform(self)
            } else {
                elseTransform(self)
            }
        }
    }

    // MARK: Optional Conditions

    /// Applies a transformation when the optional value is not `nil`.
    ///
    /// - Parameters:
    ///   - value: An optional value. When non-`nil`, the transformation receives both `self` and the unwrapped value.
    ///   - transform: A transformation applied when `value` is non-`nil`.
    /// - Returns: The transformed view when `value` is non-`nil`; otherwise `self`.
    @inlinable
    func ifLet<T, Transform: View>(_ value: T?, transform: (Self, T) -> Transform) -> some View {
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
    /// - Parameters:
    ///   - value: An optional value. When non-`nil`, `someTransform` is applied with the unwrapped value.
    ///   - someTransform: A transformation applied when `value` is non-`nil`.
    ///   - noneTransform: A transformation applied when `value` is `nil`.
    /// - Returns: The result of `someTransform(self, value)` when `value` is non-`nil`; otherwise `noneTransform(self)`.
    @inlinable
    func ifLetElse<T, SomeTransform: View, NoneTransform: View>(
        _ value: T?,
        if someTransform: (Self, T) -> SomeTransform,
        else noneTransform: (Self) -> NoneTransform
    ) -> some View {
        Group {
            if let value {
                someTransform(self, value)
            } else {
                noneTransform(self)
            }
        }
    }
}
