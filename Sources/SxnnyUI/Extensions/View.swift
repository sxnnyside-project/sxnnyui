//
//  View.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

// MARK: - View Utilities

public extension View {

    // MARK: Visibility

    /// Conditionally hides the view with an optional animation.
    ///
    /// The view’s opacity is animated between 1 and 0 and hit testing is disabled while hidden.
    ///
    /// - Parameters:
    ///   - isHidden: A Boolean value that determines whether the view is hidden.
    ///   - animation: The animation to use when transitioning visibility. Defaults to `.easeInOut(duration: 0.3)`.
    /// - Returns: A view that conditionally hides its content.
    @inlinable
    func hidden(_ isHidden: Bool, animation: Animation? = .easeInOut(duration: 0.3)) -> some View {
        modifier(HideModifier(isHidden: isHidden, animation: animation))
    }

    // MARK: Card Style

    /// Applies a simple card style with background, corner radius, and drop shadow.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius to apply. Defaults to `12`.
    ///   - shadowRadius: The blur radius of the shadow. Defaults to `6`.
    /// - Returns: A view styled as a card.
    ///
    /// - Note: Uses a platform-appropriate background color.
    @inlinable
    func cardStyle(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 6) -> some View {
        self
            .background(Self._platformBackgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.15), radius: shadowRadius, x: 0, y: 4)
    }

    // MARK: Conditional Animation

    /// Applies an animation conditionally.
    ///
    /// - Parameters:
    ///   - condition: If `true`, the provided animation is applied; otherwise, no animation is applied.
    ///   - animation: The animation to apply when `condition` is `true`. Defaults to `.easeInOut(duration: 0.3)`.
    /// - Returns: A view with conditional animation applied.
    @inlinable
    func animated(if condition: Bool, animation: Animation = .easeInOut(duration: 0.3)) -> some View {
        self.animation(condition ? animation : nil, value: UUID())
    }

    // MARK: Conditional Overlay

    /// Conditionally overlays another view.
    ///
    /// - Parameters:
    ///   - condition: If `true`, the overlay content is rendered; otherwise, it is omitted.
    ///   - alignment: The alignment for the overlay. Defaults to `.center`.
    ///   - content: A view builder that produces the overlay content.
    /// - Returns: A view with a conditional overlay.
    @inlinable
    nonisolated func overlayIf<V: View>(
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
    // Cross-platform background color for cardStyle.
    // - On platforms with UIKit/AppKit bridging, use system background.
    // - Otherwise, fall back to a neutral background.
    @usableFromInline
    static var _platformBackgroundColor: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemBackground)
        #elseif canImport(AppKit)
        return Color(NSColor.windowBackgroundColor)
        #else
        // Fallback neutral background
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
