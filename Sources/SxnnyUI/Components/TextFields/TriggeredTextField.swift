//
//  TriggeredTextField.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines a SwiftUI wrapper for UITextField, providing
//  a bindable text field with customization for placeholder and background color.
//  APIs follow Swift package and cross-platform best practices.
//

import SwiftUI

#if canImport(UIKit) && !os(watchOS)
import UIKit

/// A SwiftUI wrapper for `UITextField` with bindable content and customization.
///
/// Use this view to display a UIKit `UITextField` within SwiftUI, allowing for binding,
/// placeholder, and background color customization. Handles text changes and return key events.
///
/// Example usage:
/// ```swift
/// @State private var text = ""
///
/// TriggeredTextField(
///     text: $text,
///     placeholder: "Enter name",
///     backgroundColor: .systemGray6
/// )
/// ```
///
/// - Note: Available only on platforms where UIKit is present (not watchOS).
/// - Important: Text updates are capitalized automatically in this implementation for demonstration.
///
@MainActor
public struct TriggeredTextField: UIViewRepresentable {
    // MARK: - Coordinator

    /// Coordinator for delegate and action handling.
    public class Coordinator: NSObject, UITextFieldDelegate {
        /// Reference to the parent field for updating binding.
        var parent: TriggeredTextField

        /// Initializes the coordinator.
        /// - Parameter parent: Parent field.
        init(parent: TriggeredTextField) {
            self.parent = parent
        }

        /// Handles return key events.
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        /// Updates the binding on text change.
        @objc func textChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    // MARK: - Bindings & Properties

    /// Bindable text content.
    @Binding public var text: String

    /// Placeholder shown when empty.
    public var placeholder: String

    /// The background color of the text field.
    public var backgroundColor: UIColor

    // MARK: - UIViewRepresentable

    /// Creates the coordinator for delegate and target/action.
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    /// Creates and configures the UIKit text field.
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.keyboardType = .namePhonePad
        textField.placeholder = placeholder
        textField.backgroundColor = backgroundColor
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        return textField
    }

    /// Updates the UIKit text field with new binding values.
    public func updateUIView(_ uiView: UITextField, context: Context) {
        let capitalizedText = text.capitalized // Example: auto-capitalization
        uiView.text = capitalizedText
        uiView.backgroundColor = backgroundColor
    }

    // MARK: - Initialization

    /// Creates a new triggered text field.
    ///
    /// - Parameters:
    ///   - text: Bindable string content.
    ///   - placeholder: Placeholder text shown when empty.
    ///   - backgroundColor: Background color for the text field.
    public init(
        text: Binding<String>,
        placeholder: String,
        backgroundColor: UIColor
    ) {
        self._text = text
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
    }
}

#else

/// A no-op stub for platforms without UIKit.
@MainActor
public struct TriggeredTextField: View {
    @Binding public var text: String
    public var placeholder: String
    public var backgroundColor: Any

    public var body: some View {
        // Empty view for non-UIKit platforms.
        EmptyView()
    }

    public init(
        text: Binding<String>,
        placeholder: String,
        backgroundColor: Any
    ) {
        self._text = text
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
    }
}

#endif
