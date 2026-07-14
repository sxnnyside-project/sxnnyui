//
//  HideKeyboardModifier.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - Dismiss Keyboard on Background Tap
//
// Dismisses the keyboard when the user taps anywhere outside the active input field —
// one of the most common pieces of boilerplate in form-heavy SwiftUI apps, and one that
// is easy to get subtly wrong (forgetting `.contentShape(Rectangle())` leaves only the
// view's visible content tappable, not its full frame). On platforms where there is no
// keyboard/responder chain concept, this modifier is a no-op.

#if canImport(UIKit) && !os(watchOS)
    import UIKit

    @MainActor
    private struct DismissesKeyboardOnTapModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                }
        }
    }

#else

    @MainActor
    private struct DismissesKeyboardOnTapModifier: ViewModifier {
        func body(content: Content) -> some View { content }
    }

#endif

// MARK: - Public API

extension View {
    /// Dismisses the keyboard when the user taps anywhere outside the active input field.
    ///
    /// ```swift
    /// Form {
    ///     TextField("Name", text: $name)
    ///     TextField("Email", text: $email)
    /// }
    /// .dismissesKeyboardOnTap()
    /// ```
    ///
    /// On platforms without a keyboard/responder chain (such as watchOS), this is a
    /// no-op and returns the view unchanged.
    @MainActor
    public func dismissesKeyboardOnTap() -> some View {
        self.modifier(DismissesKeyboardOnTapModifier())
    }
}
