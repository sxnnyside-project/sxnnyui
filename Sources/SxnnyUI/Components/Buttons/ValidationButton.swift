//
//  ValidationButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 01/04/25.
//
//  A customizable button that validates a condition before performing an action.
//  Adapts styling for available Apple platforms and OS versions.
//  - Provides clear documentation for Swift package consumers.
//  - Styles adapt gracefully on older macOS/iOS versions.
//
//  Example usage:
//  ```swift
//  ValidationButton(
//      destination: { print("Navigation or operation!") },
//      validationAction: { isFormValid },
//      labelTitle: "Check Form",
//      labelIcon: "checkmark.seal",
//      buttonTitle: "Validate",
//      buttonIcon: "checkmark.circle.fill"
//  )
//  ```
//

import SwiftUI

/// A button that validates a condition before performing a provided destination action.
///
/// - Parameters:
///   - destination: The action to perform if validation succeeds.
///   - validationAction: Returns `true` if the button's action should run.
///   - labelTitle: The text shown next to the label icon.
///   - labelIcon: The system image name for the label icon.
///   - buttonTitle: The text shown for the button (not currently displayed but available for future use).
///   - buttonIcon: The system image name for the button icon (not currently displayed but available for future use).
///   - labelFontWeight: The label font weight. Defaults to `.heavy`.
///   - labelControlSize: The label control size. Defaults to `.regular`.
///   - labelPadding: Vertical padding for the label. Defaults to `15`.
///   - buttonTint: The color tint for the button. Defaults to `.green`.
///
/// Availability:
/// - macOS 11.0+, iOS 14.0+, tvOS 14.0+, watchOS 7.0+
///
/// > Note: Some advanced button styles require later OS versions and will gracefully degrade.
@MainActor
public struct ValidationButton: View {
    private let destination: () -> Void
    private let validationAction: () -> Bool
    private let labelTitle: String
    private let labelIcon: String
    private let buttonTitle: String
    private let buttonIcon: String
    private let labelFontWeight: Font.Weight
    private let labelControlSize: ControlSize
    private let labelPadding: CGFloat
    private let buttonTint: Color

    /// Creates a new `ValidationButton`.
    /// - See struct-level doc for parameter descriptions.
    public init(
        destination: @escaping () -> Void,
        validationAction: @escaping () -> Bool,
        labelTitle: String = "Tap to validate",
        labelIcon: String = "arrowtriangle.right.fill",
        buttonTitle: String = "Validate",
        buttonIcon: String = "checkmark.circle",
        labelFontWeight: Font.Weight = .heavy,
        labelControlSize: ControlSize = .regular,
        labelPadding: CGFloat = 15,
        buttonTint: Color = .green
    ) {
        self.destination = destination
        self.validationAction = validationAction
        self.labelTitle = labelTitle
        self.labelIcon = labelIcon
        self.buttonTitle = buttonTitle
        self.buttonIcon = buttonIcon
        self.labelFontWeight = labelFontWeight
        self.labelControlSize = labelControlSize
        self.labelPadding = labelPadding
        self.buttonTint = buttonTint
    }

    public var body: some View {
        Button(action: {
            if validationAction() {
                destination()
            }
        }) {
            _ValidationButtonLabel(
                title: labelTitle,
                systemImage: labelIcon,
                fontWeight: labelFontWeight,
                controlSize: labelControlSize,
                verticalPadding: labelPadding
            )
        }
        .applyBestButtonStyle()
        .applyBestButtonTint(buttonTint)
    }
}

// MARK: - Helpers & Styling Extensions

private struct _ValidationButtonLabel: View {
    let title: String
    let systemImage: String
    let fontWeight: Font.Weight
    let controlSize: ControlSize
    let verticalPadding: CGFloat

    var body: some View {
        Group {
            if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Label(title, systemImage: systemImage)
                    .applyBestFontWeight(fontWeight)
                    .applyBestControlSize(controlSize)
                    .padding(.vertical, verticalPadding)
                    .applyBestLabelStyle()
                    .frame(maxWidth: .infinity)
            } else {
                HStack {
                    // Use a fallback for Image(systemName:) on earlier OSes
                    if #available(macOS 11.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                        Image(systemName: systemImage)
                    }
                    Text(title)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - Conditional Style Modifiers

private extension View {
    @ViewBuilder
    func applyBestButtonStyle() -> some View {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.buttonStyle(.borderedProminent)
        } else if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            self.buttonStyle(.bordered)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyBestButtonTint(_ color: Color) -> some View {
        if #available(macOS 13.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.tint(color)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyBestFontWeight(_ weight: Font.Weight) -> some View {
        if #available(macOS 13.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.fontWeight(weight)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyBestLabelStyle() -> some View {
        if #available(macOS 11.3, iOS 14.5, tvOS 14.5, watchOS 7.4, *) {
            self.labelStyle(.titleAndIcon)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyBestControlSize(_ size: ControlSize) -> some View {
        if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            self.controlSize(size)
        } else {
            self
        }
    }
}
