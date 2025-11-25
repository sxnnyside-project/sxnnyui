//
//  ValidationLabel.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines the `ValidationLabel` view for SxnnyUI.
//  It displays a label with swipe-to-validate action and is designed for use in forms or gated navigation.
//  All APIs are documented and annotated for Swift package best practices and platform compatibility.
//
//  Example usage:
//  ```swift
//  if #available(iOS 16.0, macOS 13.0, *) {
//      ValidationLabel(
//          destination: { print("Navigated!") },
//          validationAction: { isInputValid }
//      )
//      .labelFontWeight(.bold)
//      .buttonTint(.blue)
//  }
//  ```
//

import SwiftUI

// MARK: - ValidationLabel

/// A swipe-to-validate label with an optional trailing action button.
///
/// `ValidationLabel` presents a label (with icon) that supports swipe actions to trigger validation logic.
/// If the validation passes, a destination action is called (e.g., navigation or state update). You can
/// customize label and button appearance using the provided modifiers.
///
/// > Note: This view requires iOS 16.0 or later, or macOS 13.0 or later due to the use of `.swipeActions` and label presentation APIs.
///
/// ### Example
/// ```swift
/// ValidationLabel(
///     destination: { /* navigate or perform action */ },
///     validationAction: { /* return true if valid */ }
/// )
/// .labelFontWeight(.bold)
/// .buttonTint(.green)
/// ```
///
/// - Requires: iOS 16.0+ or macOS 13.0+
///
/// - Tag: ValidationLabel
@available(iOS 16.0, macOS 13.0, *)
public struct ValidationLabel: View {
    // MARK: - Properties

    /// The action to perform when validation succeeds.
    public let destination: () -> Void
    /// The validation closure. Return `true` to proceed.
    public let validationAction: () -> Bool

    /// The label's text.
    public let labelTitle: String
    /// The SF Symbol for the label icon.
    public let labelIcon: String
    /// The button's text.
    public let buttonTitle: String
    /// The SF Symbol for the button icon.
    public let buttonIcon: String

    /// The font weight for the label.
    public var labelFontWeight: Font.Weight = .heavy
    /// The control size for the label.
    public var labelControlSize: ControlSize = .regular
    /// The vertical padding for the label.
    public var labelPadding: CGFloat = 15
    /// The tint color for the button.
    public var buttonTint: Color = .green

    // MARK: - Initializer

    /// Creates a new validation label.
    ///
    /// - Parameters:
    ///   - destination: A closure to run when validation succeeds.
    ///   - validationAction: A closure returning `true` to allow navigation or action.
    ///   - labelTitle: Text for the label. Defaults to "Desliza para verificar".
    ///   - labelIcon: SF Symbol for the label. Defaults to `"arrowtriangle.right.fill"`.
    ///   - buttonTitle: Button text. Defaults to "Validar".
    ///   - buttonIcon: SF Symbol for the button. Defaults to `"checkmark.circle"`.
    public init(
        destination: @escaping () -> Void,
        validationAction: @escaping () -> Bool,
        labelTitle: String = "Desliza para verificar",
        labelIcon: String = "arrowtriangle.right.fill",
        buttonTitle: String = "Validar",
        buttonIcon: String = "checkmark.circle"
    ) {
        self.destination = destination
        self.validationAction = validationAction
        self.labelTitle = labelTitle
        self.labelIcon = labelIcon
        self.buttonTitle = buttonTitle
        self.buttonIcon = buttonIcon
    }

    // MARK: - View Body

    public var body: some View {
        Group {
            // Label, swipeActions, fontWeight, labelStyle, etc. require iOS 16/macOS 13+
            if #available(iOS 16.0, macOS 13.0, *) {
                Label(labelTitle, systemImage: labelIcon)
                    .fontWeight(labelFontWeight)
                    .controlSize(labelControlSize)
                    .padding(.vertical, labelPadding)
                    .ifAvailableLabelStyleTitleAndIcon()
                    .swipeActions(edge: .leading) {
                        Button {
                            if validationAction() {
                                destination()
                            }
                        } label: {
                            Label(buttonTitle, systemImage: buttonIcon)
                                .ifAvailableLabelStyleIconOnly()
                        }
                        .tint(buttonTint)
                    }
            } else {
                // Fallback for unsupported platforms (render nothing)
                EmptyView()
            }
        }
    }

    // MARK: - Modifiers

    /// Sets the font weight for the label.
    ///
    /// - Parameter fontWeight: The font weight to use.
    /// - Returns: A new `ValidationLabel` with the updated font weight.
    public func labelFontWeight(_ fontWeight: Font.Weight) -> ValidationLabel {
        var copy = self
        copy.labelFontWeight = fontWeight
        return copy
    }

    /// Sets the control size for the label.
    ///
    /// - Parameter controlSize: The control size to use.
    /// - Returns: A new `ValidationLabel` with the updated control size.
    public func labelControlSize(_ controlSize: ControlSize) -> ValidationLabel {
        var copy = self
        copy.labelControlSize = controlSize
        return copy
    }

    /// Sets the vertical padding for the label.
    ///
    /// - Parameter padding: The vertical padding value.
    /// - Returns: A new `ValidationLabel` with the updated padding.
    public func labelPadding(_ padding: CGFloat) -> ValidationLabel {
        var copy = self
        copy.labelPadding = padding
        return copy
    }

    /// Sets the tint color for the button.
    ///
    /// - Parameter color: The color to use for the button tint.
    /// - Returns: A new `ValidationLabel` with the updated button tint.
    public func buttonTint(_ color: Color) -> ValidationLabel {
        var copy = self
        copy.buttonTint = color
        return copy
    }
}

// MARK: - Conditional Modifier Extensions

private extension View {
    /// Applies `.labelStyle(.titleAndIcon)` if available on this platform.
    @ViewBuilder
    func ifAvailableLabelStyleTitleAndIcon() -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            self.labelStyle(.titleAndIcon)
        } else if #available(iOS 15.0, macOS 11.3, *) {
            self.labelStyle(.titleAndIcon)
        } else {
            self
        }
    }

    /// Applies `.labelStyle(.iconOnly)` if available on this platform.
    @ViewBuilder
    func ifAvailableLabelStyleIconOnly() -> some View {
        if #available(iOS 14.0, macOS 11.0, *) {
            self.labelStyle(.iconOnly)
        } else {
            self
        }
    }
}
