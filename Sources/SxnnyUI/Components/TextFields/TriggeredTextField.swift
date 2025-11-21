//
//  TriggeredTextField.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// A SwiftUI wrapper for `UITextField` that provides additional customization and functionality.
/// The `TriggeredTextField` allows for binding text, setting a placeholder, and customizing the background color.
/// It uses a `Coordinator` to handle delegate methods and text changes.
public struct TriggeredTextField: UIViewRepresentable {
    /// A coordinator class to manage `UITextField` delegate methods and handle text changes.
    public class Coordinator: NSObject, UITextFieldDelegate {
        /// A reference to the parent `TriggeredTextField`.
        var parent: TriggeredTextField
        
        /// Initializes a new instance of `Coordinator`.
        /// - Parameter parent: The parent `TriggeredTextField` instance.
        init(parent: TriggeredTextField) {
            self.parent = parent
        }
        
        /// Handles the return key press on the `UITextField`.
        /// - Parameter textField: The `UITextField` instance.
        /// - Returns: A Boolean value indicating whether the text field should process the return key.
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
    
    /// A binding to the text content of the text field.
    @Binding public var text: String
    /// The placeholder text displayed when the text field is empty.
    public var placeholder: String
    /// The background color of the text field.
    public var backgroundColor: UIColor
    
    /// Creates a coordinator instance to manage the text field's delegate methods.
    /// - Returns: A new `Coordinator` instance.
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    /// Creates the `UITextField` instance and configures its properties.
    /// - Parameter context: The context containing the coordinator.
    /// - Returns: A configured `UITextField` instance.
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
    
    /// Updates the `UITextField` instance with new data.
    /// - Parameters:
    ///   - uiView: The `UITextField` instance.
    ///   - context: The context containing the coordinator.
    public func updateUIView(_ uiView: UITextField, context: Context) {
        let capitalizedText = text.capitalized
        uiView.text = capitalizedText
        uiView.backgroundColor = backgroundColor
    }
    
    /// Initializes a new instance of `TriggeredTextField`.
    /// - Parameters:
    ///   - text: A binding to the text content of the text field.
    ///   - placeholder: The placeholder text displayed when the text field is empty.
    ///   - backgroundColor: The background color of the text field.
    public init(text: Binding<String>, placeholder: String, backgroundColor: UIColor) {
        self._text = text
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
    }
}

public extension TriggeredTextField.Coordinator {
    /// Handles text changes in the `UITextField` and updates the parent binding.
    /// - Parameter textField: The `UITextField` instance.
    @objc func textChanged(_ textField: UITextField) {
        parent.text = textField.text ?? ""
    }
}
