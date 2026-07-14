//
//  Focus.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 14/07/26.
//

import SwiftUI

// MARK: - Focus
//
// Sequential focus navigation and reliable programmatic focus are both boilerplate a
// caller re-derives on every form. The order state itself belongs to the caller — they
// already declare a `Hashable & CaseIterable` enum of field identifiers to drive
// `@FocusState`, and this package does not duplicate or own that state. What it
// provides is the ergonomics on top: advancing through the caller's own case order, and
// reliably focusing a field on appearance without hitting the well-known "set inside
// `.onAppear` and nothing happens" footgun.

// MARK: - Sequential Advance

extension FocusState.Binding {
    /// Advances focus to the next case in `Value.allCases`, in declaration order.
    ///
    /// The caller owns the field-identifier enum and its case order — this method only
    /// computes and assigns the next case relative to the binding's current value. When
    /// the current value is already the last case (or `nil`, or not found in
    /// `allCases`), focus resigns by setting the binding to `nil`, matching the
    /// behavior a "Tab" key press would have at the end of a form.
    ///
    /// ```swift
    /// enum Field: Hashable, CaseIterable { case name, email, phone }
    ///
    /// struct SignUpForm: View {
    ///     @FocusState private var focusedField: Field?
    ///
    ///     var body: some View {
    ///         Form {
    ///             TextField("Name", text: $name)
    ///                 .focused($focusedField, equals: .name)
    ///                 .onSubmit { $focusedField.advanceToNextField() }
    ///             TextField("Email", text: $email)
    ///                 .focused($focusedField, equals: .email)
    ///                 .onSubmit { $focusedField.advanceToNextField() }
    ///         }
    ///     }
    /// }
    /// ```
    @MainActor
    public func advanceToNextField<Field>() where Value == Field?, Field: Hashable & CaseIterable {
        let allCases = Array(Field.allCases)
        guard let current = wrappedValue,
            let currentIndex = allCases.firstIndex(of: current)
        else {
            wrappedValue = nil
            return
        }

        let nextIndex = allCases.index(after: currentIndex)
        wrappedValue = nextIndex < allCases.endIndex ? allCases[nextIndex] : nil
    }
}

extension View {
    /// Wires `.onSubmit` to advance `focus` to the next case in its `Value.allCases`
    /// order, producing a "Tab-like" return-key chain through a form's fields with no
    /// boilerplate at each field beyond this one modifier.
    ///
    /// ```swift
    /// TextField("Name", text: $name)
    ///     .focused($focusedField, equals: .name)
    ///     .advancesFocusOnSubmit($focusedField)
    /// ```
    ///
    /// - Parameter focus: The `@FocusState` binding this field participates in.
    /// - Returns: A view whose return-key submission advances `focus` to the next
    ///   field, or resigns focus after the last one.
    @MainActor
    public func advancesFocusOnSubmit<Value: Hashable & CaseIterable>(
        _ focus: FocusState<Value?>.Binding
    ) -> some View {
        self.onSubmit {
            focus.advanceToNextField()
        }
    }
}

// MARK: - Focus on Appear

extension View {
    /// Sets `focus` to `target` shortly after this view appears.
    ///
    /// Setting `@FocusState` synchronously inside `.onAppear` frequently fails to
    /// actually move focus, because the view isn't fully installed in the responder
    /// chain at that point yet. This modifier defers the assignment by one run-loop
    /// hop via `.task`, which reliably lands after installation while still happening
    /// before the user perceives any delay.
    ///
    /// ```swift
    /// enum Field: Hashable, CaseIterable { case name, email }
    /// @FocusState private var focusedField: Field?
    ///
    /// TextField("Name", text: $name)
    ///     .focused($focusedField, equals: .name)
    ///     .focusOnAppear($focusedField, equals: .name)
    /// ```
    ///
    /// - Parameters:
    ///   - focus: The `@FocusState` binding to assign.
    ///   - target: The value to focus once the view has appeared.
    /// - Returns: A view that focuses `target` shortly after appearing.
    @MainActor
    public func focusOnAppear<Value: Hashable>(_ focus: FocusState<Value?>.Binding, equals target: Value) -> some View {
        self.task {
            // A single `Task` yield is enough to let SwiftUI finish installing this
            // view in the responder chain before focus is requested; setting focus
            // synchronously in `.onAppear` is the well-known pattern that silently
            // fails to focus.
            await Task.yield()
            focus.wrappedValue = target
        }
    }

    /// Sets `focus` to `true` shortly after this view appears.
    ///
    /// The single-field convenience form of ``focusOnAppear(_:equals:)`` for views
    /// backed by a plain `Bool` `@FocusState`, deferred the same way to avoid the
    /// "focus set in `.onAppear` doesn't take" footgun.
    ///
    /// ```swift
    /// @FocusState private var isFocused: Bool
    ///
    /// TextField("Name", text: $name)
    ///     .focused($isFocused)
    ///     .focusOnAppear($isFocused)
    /// ```
    ///
    /// - Parameter focus: The `@FocusState` boolean binding to set to `true`.
    /// - Returns: A view that focuses itself shortly after appearing.
    @MainActor
    public func focusOnAppear(_ focus: FocusState<Bool>.Binding) -> some View {
        self.task {
            await Task.yield()
            focus.wrappedValue = true
        }
    }
}
