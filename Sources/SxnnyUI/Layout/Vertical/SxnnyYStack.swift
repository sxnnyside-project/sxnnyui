//
//  SxnnyYStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyYStack`, a convenience wrapper for SwiftUI's `VStack`
//  with SxnnyUI’s standard default alignment and spacing.
//
//  Usage Example:
//    SxnnyYStack(spacing: 20) {
//        Text("Hello")
//        Text("World")
//    }
//
//  For large or dynamic content in scrollable lists, consider using `SxnnyLazyYStack`.
//

import SwiftUI

// MARK: - SxnnyYStack

/// A vertical stack (`VStack`) with SxnnyUI’s preferred alignment and spacing.
///
/// Use `SxnnyYStack` for vertically arranging views with consistent spacing and alignment
/// as defined by your design system (`SxnnyTheme`). For lazy loading in lists,
/// use `SxnnyLazyYStack` instead.
///
/// - Important: This stack is always eager; it does not use lazy loading.
/// - SeeAlso: `SxnnyLazyYStack`
///
/// ### Example
/// ```swift
/// SxnnyYStack(alignment: .center, spacing: 16) {
///     Text("A")
///     Text("B")
/// }
/// ```
public struct SxnnyYStack<Content: View>: View {
    // MARK: Properties

    /// The horizontal alignment for the contents of the stack.
    private let alignment: HorizontalAlignment

    /// The spacing between adjacent views in the stack.
    private let spacing: CGFloat

    /// The content displayed within the stack.
    private let content: () -> Content

    // MARK: Initialization

    /// Creates a vertical stack with customizable alignment and spacing.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment of the stack’s children. Defaults to `.leading`.
    ///   - spacing: The spacing between children. Defaults to `SxnnyTheme.defaultSpacing`.
    ///   - content: A view builder that constructs the stack’s content.
    public init(
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = SxnnyTheme.defaultSpacing,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    // MARK: View Body

    /// The view’s body, rendering a vertically arranged stack of views.
    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
}
