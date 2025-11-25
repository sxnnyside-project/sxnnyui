//
//  SxnnyContainer.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyContainer`, a reusable SwiftUI view that provides
//  a consistent padded, rounded, and shadowed container for app content. It
//  promotes visual coherence and reduces repetition when building layouts with
//  custom backgrounds, corner radii, and shadows.
//
//  Usage Example:
//    SxnnyContainer {
//        Text("Hello, SxnnyUI!")
//    }
//

import SwiftUI

// MARK: - SxnnyContainer

/// A reusable container view that applies consistent background, corner radius, shadow, and padding.
/// Use this to wrap content in a visually distinct surface, such as cards or grouped panels.
public struct SxnnyContainer<Content: View>: View {
    /// The content displayed inside the container.
    private let content: () -> Content
    /// The background color of the container.
    private let backgroundColor: Color
    /// The corner radius for rounding the container's edges.
    private let cornerRadius: CGFloat
    /// The blur radius of the container's drop shadow.
    private let shadowRadius: CGFloat
    /// The padding applied to the content inside the container.
    private let padding: CGFloat

    /// Creates a `SxnnyContainer` with customizable appearance.
    ///
    /// - Parameters:
    ///   - backgroundColor: The background color of the container. Defaults to `SxnnyTheme.background`.
    ///   - cornerRadius: The corner radius for rounded edges. Defaults to `12`.
    ///   - shadowRadius: The blur radius of the drop shadow. Defaults to `5`.
    ///   - padding: The padding inside the container. Defaults to `SxnnyTheme.defaultPadding`.
    ///   - content: A view builder that provides the container's content.
    public init(
        backgroundColor: Color = SxnnyTheme.background,
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 5,
        padding: CGFloat = SxnnyTheme.defaultPadding,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.padding = padding
        self.content = content
    }

    /// The view’s body, rendering the padded, rounded, shadowed container with its content.
    public var body: some View {
        content()
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
}
