//
//  RoundedButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//


import SwiftUI

//
//  RoundedButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// A customizable rounded button that supports dynamic labels, colors, and disabled states.
public struct RoundedButton<Label: View>: View {
    /// The label of the button, which can be any SwiftUI `View`.
    private let label: Label
    
    /// The action to perform when the button is tapped.
    private let action: () -> Void
    
    /// A closure that determines whether the button is disabled.
    private let isDisabled: () -> Bool
    
    /// The background color of the button, customizable via the environment.
    @Environment(\.roundedButtonBackgroundColor) private var backgroundColor

    /// Creates a `RoundedButton` with a custom label.
    /// - Parameters:
    ///   - action: The action to perform when the button is tapped.
    ///   - disabled: A closure that determines whether the button is disabled. Defaults to `false`.
    ///   - label: A view builder that provides the label for the button.
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
    /// - Parameters:
    ///   - text: The text to display as the button's label.
    ///   - action: The action to perform when the button is tapped.
    ///   - disabled: A closure that determines whether the button is disabled. Defaults to `false`.
    public init(
        text: String,
        action: @escaping () -> Void,
        disabled: @escaping () -> Bool = { false }
    ) where Label == Text {
        self.label = Text(text)
        self.action = action
        self.isDisabled = disabled
    }

    /// The content and behavior of the button.
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

/// A private key for storing the background color of the `RoundedButton` in the environment.
private struct RoundedButtonBackgroundColorKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

extension EnvironmentValues {
    /// The background color for `RoundedButton`. Defaults to `.accentColor`.
    var roundedButtonBackgroundColor: Color {
        get { self[RoundedButtonBackgroundColorKey.self] }
        set { self[RoundedButtonBackgroundColorKey.self] = newValue }
    }
}

extension View {
    /// Sets the background color for `RoundedButton` instances within this view.
    /// - Parameter color: The color to use as the background for `RoundedButton`.
    /// - Returns: A view with the modified environment value.
    public func backgroundColor(_ color: Color) -> some View {
        environment(\.roundedButtonBackgroundColor, color)
    }
}
