//
//  FocusText.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 30/04/25.
//


/// A custom text field that supports focus state management.
/// This view allows you to bind a focus state to control whether the text field is focused.
import SwiftUI

public struct FocusTextField: View {
    /// The text to display and edit in the text field.
    @Binding private var text: String
    /// The focus state binding to control the focus of the text field.
    @FocusState.Binding private var isFocused: Bool

    /// Initializes a `FocusText` view.
    /// - Parameters:
    ///   - text: A binding to the text to display and edit.
    ///   - isFocused: A binding to the focus state of the text field.
    public init(text: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self._text = text
        self._isFocused = isFocused
    }

    /// The body of the `FocusText` view.
    /// Displays a text field that can be focused or unfocused based on the focus state.
    public var body: some View {
        TextField("Enter text", text: $text)
            .focused($isFocused)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
}
