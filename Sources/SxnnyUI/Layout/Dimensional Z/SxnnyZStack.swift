//
//  SxnnyZStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyZStack`, a custom wrapper around SwiftUI's `ZStack`
//  that applies SxnnyUI's standard alignment, padding, and background styling.
//  Use `SxnnyZStack` to overlay content with consistent theming, spacing, and alignment.
//  All values default to the standards defined in `SxnnyTheme`.
//
//  Usage Example:
//    SxnnyZStack {
//         Rectangle().fill(Color.blue)
//         Text("Overlay")
//     }
//
//  For a dynamic overlay stack, use `SxnnyZStack` to ensure consistent layout and appearance

import SwiftUI

// MARK: - SxnnyZStack

/// A custom `ZStack` that applies SxnnyUI’s standard alignment, padding, and background styling.
///
/// Use `SxnnyZStack` to overlay content with consistent theming, spacing, and alignment across your application.
/// All values default to the standards defined in `SxnnyTheme`.
///
/// ### Example
/// ```swift
/// SxnnyZStack(alignment: .topTrailing) {
///     Rectangle().fill(Color.blue)
///     Text("Overlay")
/// }
/// ```
///
/// - Note: The `spacing` parameter is included for API consistency, although SwiftUI’s `ZStack` does not use it directly.
/// - SeeAlso: `SxnnyTheme`
@MainActor
public struct SxnnyZStack<Content: View>: View {
    // MARK: Properties

    /// The alignment of the stack’s content. Defaults to `.center`.
    private let alignment: Alignment
    /// The spacing between overlapping elements.
    ///
    /// - Note: Included for future expansion and API harmony; unused by `ZStack`.
    private let spacing: CGFloat
    /// The content to be displayed in the stack.
    private let content: () -> Content

    // MARK: Initialization

    /// Creates a stack that overlays its children using the specified alignment, spacing, and content.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack. Defaults to `.center`.
    ///   - spacing: The distance between overlapping elements. Defaults to `SxnnyTheme.defaultSpacing`. (Unused)
    ///   - content: A view builder that creates the content of this stack.
    public init(
        alignment: Alignment = .center,
        spacing: CGFloat = SxnnyTheme.defaultSpacing,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    // MARK: View Body

    /// The view’s body, rendering an overlaid stack of views with standard padding and a themed background.
    public var body: some View {
        ZStack(alignment: alignment) {
            content()
        }
        .padding(SxnnyTheme.defaultPadding)
        .background(SxnnyTheme.background.opacity(0.01))
    }
}
