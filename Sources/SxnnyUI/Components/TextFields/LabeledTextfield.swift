//
//  LabeledTextField.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines a labeled numeric text field with focus, disabled, and placeholder support.
//  All APIs are documented for clarity and platform compatibility, suitable for Swift package use.
//

import SwiftUI

/// A labeled text field for numeric values, supporting placeholder, focus, and disabled state.
///
/// Use this view in forms where you need a label, a floating-point entry field, and
/// control over whether the field is focused or disabled.
///
/// Example usage:
/// ```swift
/// @State private var value: Double = 0.0
/// @State private var disabled = false
/// @FocusState private var isFocused: Bool
///
/// LabeledTextField(
///     text: "Total",
///     placeholder: "Enter amount",
///     disabled: $disabled,
///     value: $value,
///     isFocused: $isFocused
/// )
/// ```
///
/// - Important: Requires macOS 12.0+, iOS 15.0+, tvOS 15.0+, or watchOS 8.0+ due to focus state.
/// - Note: Decimal keyboard type is only available on iOS.
///
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@MainActor
public struct LabeledTextField: View {
    // MARK: - Properties

    /// The label displayed next to the text field.
    public let text: String

    /// The placeholder, shown when the value is empty or zero.
    public let placeholder: String

    /// Bindable disabled state for the text field.
    @Binding public var disabled: Bool

    /// The bound floating-point value displayed and edited in the field.
    @Binding public var value: Double

    /// Bindable focus state for the text field.
    @FocusState.Binding public var isFocused: Bool

    // MARK: - Initialization

    /// Creates a labeled numeric text field.
    ///
    /// - Parameters:
    ///   - text: The label shown next to the field.
    ///   - placeholder: Placeholder shown when field is empty or zero.
    ///   - disabled: Whether the field is user-editable.
    ///   - value: The numeric value bound to the field.
    ///   - isFocused: The focus state binding for this field.
    public init(
        text: String,
        placeholder: String,
        disabled: Binding<Bool>,
        value: Binding<Double>,
        isFocused: FocusState<Bool>.Binding
    ) {
        self.text = text
        self.placeholder = placeholder
        self._disabled = disabled
        self._value = value
        self._isFocused = isFocused
    }

    // MARK: - View

    /// The labeled text field content.
    public var body: some View {
        HStack {
            Text(text)
            ZStack(alignment: .leading) {
                if shouldShowPlaceholder {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                }
                #if os(iOS)
                TextField("", value: $value, formatter: FloatFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                #else
                TextField("", value: $value, formatter: FloatFormatter())
                    .textFieldStyle(.roundedBorder)
                #endif
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.trailing, 10)
        .disabled(disabled)
        .focused($isFocused)
    }

    // MARK: - Private Helpers

    /// Determines whether the placeholder should be visible.
    private var shouldShowPlaceholder: Bool {
        FloatFormatter.string(from: value)?.isEmpty != false
    }
}
