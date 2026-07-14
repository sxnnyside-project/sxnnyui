//
//  RoundedProminentButtonStyle.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - RoundedProminentButtonStyle
//
// A full-width, prominent call-to-action button style with pressed-state feedback and
// correct disabled-state dimming built in. As a native `ButtonStyle` conformance, it
// composes directly with `Button` — including `Button`'s text, `Label`, custom-content,
// and `role:` initializers — rather than introducing a separate button type.

/// A `ButtonStyle` that renders a full-width, rounded, prominent button with pressed
/// and disabled-state feedback.
///
/// ```swift
/// Button("Submit") { submit() }
///     .buttonStyle(.roundedProminent())
///
/// Button("Delete", role: .destructive) { delete() }
///     .buttonStyle(.roundedProminent(backgroundColor: .red))
///     .disabled(!canDelete)
/// ```
public struct RoundedProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    init(backgroundColor: Color, cornerRadius: CGFloat) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(isEnabled ? backgroundColor : Color.gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

// MARK: - Static Accessor

extension ButtonStyle where Self == RoundedProminentButtonStyle {
    /// A full-width, rounded, prominent button style with pressed and disabled-state
    /// feedback.
    ///
    /// - Parameters:
    ///   - backgroundColor: The button's background color when enabled. Defaults to
    ///     `.accentColor`. Ignored (replaced by a neutral gray) when the button is
    ///     disabled.
    ///   - cornerRadius: The corner radius of the button's background. Defaults to `10`.
    public static func roundedProminent(
        backgroundColor: Color = .accentColor,
        cornerRadius: CGFloat = 10
    ) -> RoundedProminentButtonStyle {
        RoundedProminentButtonStyle(backgroundColor: backgroundColor, cornerRadius: cornerRadius)
    }
}
