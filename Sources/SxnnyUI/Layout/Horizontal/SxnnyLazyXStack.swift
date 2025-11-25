//
//  SxnnyLazyXStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyLazyXStack`, a convenience wrapper for SwiftUI's `LazyHStack`
//  with SxnnyUI’s standard default alignment and spacing. Use this for efficient,
//  horizontally scrolling stacks with large or dynamic content.
//
//  Usage Example:
//    SxnnyLazyXStack(spacing: 20) {
//        ForEach(items) { item in
//            ItemView(item: item)
//        }
//    }
//

import SwiftUI

// MARK: - SxnnyLazyXStack

/// An efficient horizontal stack (`LazyHStack`) with SxnnyUI’s preferred alignment and spacing.
///
/// `SxnnyLazyXStack` is ideal for horizontally scrolling lists with a large number of views. It ensures
/// consistent layout and performance with standard spacing and alignment.
///
/// > Note: `LazyHStack` is available on macOS 11.0+, iOS 14.0+, and other recent platforms.
///   On earlier platforms, this view will fall back to `HStack` without lazy loading.
///
/// Example:
/// ```swift
/// SxnnyLazyXStack(alignment: .bottom, spacing: 16) {
///     ForEach(items) { item in
///         ItemCell(item: item)
///     }
/// }
/// ```
public struct SxnnyLazyXStack<Content: View>: View {
    /// The vertical alignment for the contents of the stack.
    private let alignment: VerticalAlignment
    /// The spacing between adjacent views in the stack.
    private let spacing: CGFloat
    /// The content displayed within the lazy stack.
    private let content: () -> Content

    /// Creates a lazy horizontal stack with customizable alignment and spacing.
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

    /// The view’s body, rendering a horizontally arranged, lazily loaded stack of views.
    public var body: some View {
        Group {
            if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                LazyHStack(alignment: alignment, spacing: spacing) {
                    content()
                }
            } else {
                HStack(alignment: alignment, spacing: spacing) {
                    content()
                }
            }
        }
    }
}
