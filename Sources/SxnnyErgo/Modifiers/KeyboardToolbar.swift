//
//  KeyboardToolbar.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 14/07/26.
//

import SwiftUI

// MARK: - Keyboard Toolbar
//
// `.toolbar { ToolbarItemGroup(placement: .keyboard) { ... } }` already does everything
// this needs — the only problem is discoverability: `.keyboard` is one placement among
// many, easy to miss, and the boilerplate around it obscures what the call is actually
// for. This is sugar for that one call, nothing more.

extension View {
    /// Places `content` in a toolbar above the keyboard.
    ///
    /// Equivalent to `.toolbar { ToolbarItemGroup(placement: .keyboard) { content() } }`
    /// — this exists purely to make the `.keyboard` toolbar placement easier to find and
    /// reach for.
    ///
    /// ```swift
    /// TextField("Amount", value: $amount, format: .number)
    ///     .keyboardToolbar {
    ///         Spacer()
    ///         Button("Done") { isFocused = false }
    ///     }
    /// ```
    ///
    /// - Parameter content: The content placed in the keyboard toolbar.
    /// - Returns: A view with `content` installed as a keyboard toolbar.
    @MainActor
    public func keyboardToolbar(@ViewBuilder content: () -> some View) -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                content()
            }
        }
    }
}
