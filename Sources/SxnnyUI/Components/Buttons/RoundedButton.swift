//
//  RoundedButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  A customizable rounded button for SwiftUI, with support for dynamic labels, colors,
//  and disabled states. Styled for clarity, maintainability, and best practices as a Swift package component.
//
//  Example usage:
//  ```swift
//  RoundedButton(text: "Submit") { print("Tapped!") }
//      .backgroundColor(.green)
//  ```
//

import SwiftUI

// MARK: - RoundedButton

/// A customizable rounded button supporting dynamic labels, background color, and disabled state.
///
/// - Supports custom label views and a convenience text initializer.
/// - The background color can be set via the environment using `.backgroundColor(_:)`.
/// - The disabled state is resolved dynamically by a closure.
///
/// Availability:
/// - macOS 10.15+, iOS 13.0+, tvOS 13.0+, watchOS 6.0+ (all required SwiftUI APIs are available)
public struct RoundedButton<Label: View>: View {
    /// The content of the button, as a custom SwiftUI view.
    private let label: Label
    /// The action to perform when the button is tapped.
    private let action: () -> Void
    /// Closure determining whether the button is disabled.
    private let isDisabled: () -> Bool
    /// The background color, injected via the SwiftUI environment.
    @Environment(\.roundedButtonBackgroundColor) private var backgroundColor

    /// Creates a `RoundedButton` with a custom label.
    ///
    /// - Parameters:
    ///   - action: The action to perform when the button is tapped.
    ///   - disabled: Closure that determines whether the button is disabled. Defaults to `false`.
    ///   - label: View builder supplying the button's label.
    public init(
        action: @escaping () -> Void,
        disabled: @escaping () -> Bool = { false },
        @ViewBuilder label: () -> Label
    ) {
        self.label = label()
        self.action = action
        self.isDisabled = disabled
    }

    /// Creates a `RoundedButton` with a text label.
    ///
    /// - Parameters:
    ///   - text: The label text.
    ///   - action: The action to perform when the button is tapped.
    ///   - disabled: Closure that determines whether the button is disabled. Defaults to `false`.
    public init(
        text: String,
        action: @escaping () -> Void,
        disabled: @escaping () -> Bool = { false }
    ) where Label == Text {
        self.label = Text(text)
        self.action = action
        self.isDisabled = disabled
    }

    /// The body of the rounded button.
    public var body: some View {
        Button(action: action) {
            label
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDisabled() ? Color.gray : backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
        }
        .disabled(isDisabled())
        .buttonStyle(.borderless)
    }
}

// MARK: - Environment Support

/// The environment key for customizing the background color of `RoundedButton`.
private struct RoundedButtonBackgroundColorKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

public extension EnvironmentValues {
    /// The background color for `RoundedButton`. Defaults to `.accentColor`.
    var roundedButtonBackgroundColor: Color {
        get { self[RoundedButtonBackgroundColorKey.self] }
        set { self[RoundedButtonBackgroundColorKey.self] = newValue }
    }
}

public extension View {
    /// Sets the background color for `RoundedButton` instances within this view hierarchy.
    ///
    /// - Parameter color: The color to use for the button’s background.
    /// - Returns: A view that applies the color to the `RoundedButton` background.
    func backgroundColor(_ color: Color) -> some View {
        environment(\.roundedButtonBackgroundColor, color)
    }
}
