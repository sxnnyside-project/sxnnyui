//
//  ShadowedRoundedButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  Deprecated: Use `SxnnyUI.RoundedButton` instead.
//  A rounded, shadowed button with async and sync action support, gracefully
//  adapting its style and icon rendering across Apple platforms and OS versions.
//
//  Example usage:
//  ```swift
//  ShadowedRoundedButton(
//      label: "Continue",
//      systemImage: "arrow.right",
//      backgroundColor: .blue,
//      action: { print("Tapped!") }
//  )
//  ```
//

import SwiftUI

/// A rounded, shadowed button that supports both synchronous and asynchronous actions.
///
/// > Deprecated: Use `SxnnyUI.RoundedButton` instead.
///
/// - Parameters:
///   - label: The button's text.
///   - systemImage: The name of the SF Symbol to display.
///   - backgroundColor: The button's background color.
///   - disabled: If true, disables the button and displays it in gray.
///   - action: A synchronous (or asynchronous) closure to execute when pressed.
///
/// Availability:
/// - macOS 10.15+, iOS 13.0+, tvOS 13.0+, watchOS 6.0+ (with style and icon features gracefully degrading)
@available(*, deprecated, message: "Use SxnnyUI.RoundedButton instead")
@MainActor
public struct ShadowedRoundedButton: View {
    public let label: String
    public let systemImage: String
    public let backgroundColor: Color
    public let action: () -> Void
    public let asyncAction: () async -> Void
    public let disabled: Bool
    private let voidStyle: VoidStyle

    /// Identifies whether the button is synchronous or asynchronous.
    private enum VoidStyle { case sync, async }

    /// Creates a new button with a synchronous action.
    ///
    /// - Parameters:
    ///   - label: The button's text.
    ///   - systemImage: The name of the SF Symbol to display.
    ///   - backgroundColor: The button's background color.
    ///   - disabled: If true, disables the button and displays it in gray.
    ///   - action: The closure to execute when pressed.
    public init(
        label: String,
        systemImage: String,
        backgroundColor: Color,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.action = action
        self.disabled = disabled
        self.asyncAction = { }
        self.voidStyle = .sync
    }

    /// Creates a new button with an asynchronous action.
    ///
    /// - Parameters:
    ///   - label: The button's text.
    ///   - systemImage: The name of the SF Symbol to display.
    ///   - backgroundColor: The button's background color.
    ///   - disabled: If true, disables the button and displays it in gray.
    ///   - action: The asynchronous closure to execute when pressed.
    public init(
        label: String,
        systemImage: String,
        backgroundColor: Color,
        disabled: Bool = false,
        action: @escaping () async -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.asyncAction = action
        self.disabled = disabled
        self.action = { }
        self.voidStyle = .async
    }

    public var body: some View {
        Button(action: executeAction) {
            ButtonContent(
                label: label,
                systemImage: systemImage,
                backgroundColor: backgroundColor,
                disabled: disabled
            )
        }
        .disabled(disabled)
        .buttonStyle(.borderless)
    }

    /// Dispatches either the synchronous or asynchronous action.
    private func executeAction() {
        switch voidStyle {
        case .sync:
            action()
        case .async:
            Task { await asyncAction() }
        }
    }
}

// MARK: - Button Content Helper

private struct ButtonContent: View {
    let label: String
    let systemImage: String
    let backgroundColor: Color
    let disabled: Bool

    var body: some View {
        Group {
            if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Label(label, systemImage: systemImage)
                    .applySymbolRendering()
                    .applyForegroundStyle()
                    .applyFontWeight()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(disabled ? Color.gray : backgroundColor)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
            } else {
                HStack {
                    if #available(macOS 11.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                        Image(systemName: systemImage)
                    }
                    Text(label)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(disabled ? Color.gray : backgroundColor)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Conditional Style Modifiers

private extension View {
    @ViewBuilder
    func applyFontWeight() -> some View {
        if #available(macOS 13.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.fontWeight(.bold)
        } else {
            self
        }
    }

    @ViewBuilder
    func applySymbolRendering() -> some View {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.symbolRenderingMode(.hierarchical)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyForegroundStyle() -> some View {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(.white)
        } else {
            self.foregroundColor(.white)
        }
    }
}
