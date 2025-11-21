//
//  LabeledTextfield.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//


import SwiftUI

/// A SwiftUI view representing a labeled text field with a placeholder and value binding.
/// This view supports decimal input, focus state management, and enables or disables user interaction.
///
/// The `LabeledTextfield` is designed for scenarios where a text field requires a label and placeholder,
/// with additional customization for focus and disabled states.
public struct LabeledTextField: View {
    /// The label text displayed alongside the text field.
    public let text: String
    /// The placeholder text displayed when the text field is empty.
    public let placeholder: String
    /// A binding to control whether the text field is disabled.
    @Binding public var Disabled: Bool
    /// A binding to the numeric value entered in the text field.
    @Binding public var value: Double
    /// A focus state binding to manage the focus of the text field.
    @FocusState.Binding public var isFocused: Bool

    /// The body of the `LabeledTextfield` view.
    public var body: some View {
        TextField(text, value: $value, formatter: FloatFormatter())
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.leading)
            .padding(.trailing, 10)
            .textFieldStyle(.roundedBorder)
            .focused($isFocused)
            .disabled(Disabled)
            .disableAutocorrection(true)
            .overlay(
                HStack {
                    Spacer()
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                }
            )
    }

    /// Initializes a new instance of `LabeledTextfield`.
    /// - Parameters:
    ///   - text: The label text displayed alongside the text field.
    ///   - placeholder: The placeholder text displayed when the text field is empty.
    ///   - Disabled: A binding to control whether the text field is disabled.
    ///   - value: A binding to the numeric value entered in the text field.
    ///   - isFocused: A focus state binding to manage the focus of the text field.
    public init(text: String, placeholder: String, Disabled: Binding<Bool>, value: Binding<Double>, isFocused: FocusState<Bool>.Binding) {
        self.text = text
        self.placeholder = placeholder
        self._Disabled = Disabled
        self._value = value
        self._isFocused = isFocused
    }
}
