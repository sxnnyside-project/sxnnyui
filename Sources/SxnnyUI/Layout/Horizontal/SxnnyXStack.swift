//
//  SxnnyXStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyXStack`, a convenience wrapper around SwiftUI's `HStack`
//  that provides SxnnyUI's standard default alignment and spacing. Use `SxnnyXStack`
//  for consistent horizontal layout across your app.
//
//  Usage Example:
//    SxnnyXStack {
//        Image(systemName: "person")
//        Text("Profile")
//    }
//

import SwiftUI

// MARK: - SxnnyXStack

/// A horizontal stack (`HStack`) with SxnnyUI’s standard default alignment and spacing.
///
/// `SxnnyXStack` simplifies the creation of horizontally arranged views with consistent styling.
///
/// Example:
/// ```swift
/// SxnnyXStack(spacing: 12) {
///     Image(systemName: "star")
///     Text("Featured")
/// }
/// ```
public struct SxnnyXStack<Content: View>: View {
    /// The vertical alignment for the contents of the stack.
    private let alignment: VerticalAlignment
    /// The spacing between adjacent views in the stack.
    private let spacing: CGFloat
    /// The content of the stack.
    private let content: () -> Content

    /// Creates a horizontal stack with customizable alignment and spacing.
    ///
    /// - Parameters:
    ///   - alignment: The vertical alignment of the stack’s children. Defaults to `.center`.
    ///   - spacing: The spacing between children. Defaults to `SxnnyTheme.defaultSpacing`.
    ///   - content: A view builder that constructs the stack’s content.
    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat = SxnnyTheme.defaultSpacing,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    /// The view’s body, rendering a horizontally arranged stack of views.
    public var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
}
