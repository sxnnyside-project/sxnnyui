//
//  View.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

// MARK: - View Utilities

extension View {

    // MARK: Visibility

    /// Conditionally hides the view with an optional animation.
    ///
    /// The view's opacity is animated between `1` and `0`, and hit testing is disabled
    /// while hidden — unlike a bare `.opacity(0)`, the hidden view no longer intercepts
    /// taps.
    ///
    /// ```swift
    /// errorLabel
    ///     .hidden(errorMessage == nil)
    /// ```
    ///
    /// - Parameters:
    ///   - isHidden: A Boolean value that determines whether the view is hidden.
    ///   - animation: The animation to use when transitioning visibility. Defaults to
    ///     `.easeInOut(duration: 0.3)`. Pass `nil` to hide instantly.
    /// - Returns: A view that conditionally hides its content.
    @inlinable
    public func hidden(_ isHidden: Bool, animation: Animation? = .easeInOut(duration: 0.3)) -> some View {
        modifier(HideModifier(isHidden: isHidden, animation: animation))
    }

    // MARK: Card Style

    /// Applies a simple card style with background, corner radius, and drop shadow.
    ///
    /// ```swift
    /// VStack { content }
    ///     .padding()
    ///     .cardStyle()
    /// ```
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius to apply. Defaults to `12`.
    ///   - shadowRadius: The blur radius of the shadow. Defaults to `6`.
    /// - Returns: A view styled as a card, using a platform-appropriate background color.
    @inlinable
    public func cardStyle(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 6) -> some View {
        self
            .background(Self._platformBackgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.15), radius: shadowRadius, x: 0, y: 4)
    }

    // MARK: Conditional Animation

    /// Applies an animation only when a condition is `true`.
    ///
    /// Unlike calling `.animation(_:value:)` directly, this modifier keys the animation
    /// off `condition` itself, so it fires exactly when `condition` changes — not on every
    /// body re-evaluation.
    ///
    /// ```swift
    /// circle
    ///     .scaleEffect(isPulsing ? 1.2 : 1.0)
    ///     .animated(if: isPulsing)
    /// ```
    ///
    /// - Parameters:
    ///   - condition: When `true`, `animation` is applied to changes in `condition`;
    ///     when `false`, no animation is applied.
    ///   - animation: The animation to apply when `condition` is `true`. Defaults to
    ///     `.easeInOut(duration: 0.3)`.
    /// - Returns: A view with conditional animation applied.
    @inlinable
    public func animated(if condition: Bool, animation: Animation = .easeInOut(duration: 0.3)) -> some View {
        self.animation(condition ? animation : nil, value: condition)
    }

    // MARK: Conditional Overlay

    /// Conditionally overlays another view.
    ///
    /// ```swift
    /// avatar
    ///     .overlayIf(isOnline, alignment: .bottomTrailing) {
    ///         Circle().fill(.green).frame(width: 10, height: 10)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - condition: If `true`, the overlay content is rendered; otherwise, it is omitted.
    ///   - alignment: The alignment for the overlay. Defaults to `.center`.
    ///   - content: A view builder that produces the overlay content.
    /// - Returns: A view with a conditional overlay.
    @inlinable
    public func overlayIf<V: View>(
        _ condition: Bool,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V
    ) -> some View {
        overlay(
            Group {
                if condition {
                    content()
                } else {
                    EmptyView()
                }
            },
            alignment: alignment
        )
    }
}

// MARK: - Internal Helpers (usable from inlinable)

extension View {
    /// Cross-platform background color for `cardStyle`.
    @usableFromInline
    static var _platformBackgroundColor: Color {
        #if canImport(UIKit)
            return Color(UIColor.systemBackground)
        #elseif canImport(AppKit)
            return Color(NSColor.windowBackgroundColor)
        #else
            return Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        #endif
    }
}

// MARK: - Modifiers (usable from inlinable)

@usableFromInline
struct HideModifier: ViewModifier {
    @usableFromInline let isHidden: Bool
    @usableFromInline let animation: Animation?

    @usableFromInline
    init(isHidden: Bool, animation: Animation?) {
        self.isHidden = isHidden
        self.animation = animation
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content
            .opacity(isHidden ? 0 : 1)
            .animation(animation, value: isHidden)
            .allowsHitTesting(!isHidden)
    }
}
