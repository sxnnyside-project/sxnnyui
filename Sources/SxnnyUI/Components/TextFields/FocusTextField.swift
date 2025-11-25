//
//  FocusTextField.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 30/04/25.
//
//  This file defines a SwiftUI text field with modern focus state support. APIs are documented
//  using Apple-style documentation comments. Implementation is guarded for Swift package distribution,
//  following cross-platform best practices and robust error handling.
//

import SwiftUI

/// A SwiftUI text field that supports two-way focus state binding.
///
/// Use this view to create a text field whose focus can be programmatically controlled.
/// This is useful when orchestrating keyboard display and user input flow in complex forms.
///
/// ```swift
/// struct MyView: View {
///     @State private var text = ""
///     @FocusState private var isFieldFocused: Bool
///
///     var body: some View {
///         FocusTextField(text: $text, isFocused: $isFieldFocused)
///     }
/// }
/// ```
///
/// - Important: Requires macOS 12.0+, iOS 15.0+, tvOS 15.0+, watchOS 8.0+ as it uses `FocusState`.
/// - Note: The focus state enables advanced keyboard and responder management in SwiftUI.
///
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@MainActor
public struct FocusTextField: View {
    // MARK: - Bindings

    /// The text value displayed and edited in the text field.
    @Binding private var text: String

    /// The focus state for this text field, enabling control via SwiftUI's `@FocusState`.
    @FocusState.Binding private var isFocused: Bool

    // MARK: - Initialization

    /// Creates a focused text field with the specified text and focus bindings.
    ///
    /// - Parameters:
    ///   - text: A binding to the text to display and edit.
    ///   - isFocused: A binding to a `Bool` focus state for this field.
    ///
    /// - Precondition: The `isFocused` binding must be backed by a SwiftUI `@FocusState` property.
    public init(text: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self._text = text
        self._isFocused = isFocused
    }

    // MARK: - View

    /// The content and behavior of the focused text field.
    ///
    /// Displays a single-line text input. The field's focus can be controlled by toggling `isFocused`.
    public var body: some View {
        TextField("Enter text", text: $text)
            .focused($isFocused)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
}
