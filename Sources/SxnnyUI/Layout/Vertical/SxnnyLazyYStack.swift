//
//  SxnnyLazyYStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//  
//  This file defines `SxnnyLazyYStack`, a convenience wrapper for SwiftUI's `LazyVStack`
//  with SxnnyUI’s standard default alignment and spacing. Use this for efficient,
//  vertically scrolling stacks with large or dynamic content.
//
//  Usage Example:
//    SxnnyLazyYStack(spacing: 20) {
//        ForEach(items) { item in
//            ItemView(item: item)
//        }
//    }
//

import SwiftUI

// MARK: - SxnnyLazyYStack

/// An efficient vertical stack (`LazyVStack`) with SxnnyUI’s preferred alignment and spacing.
///
/// `SxnnyLazyYStack` is ideal for vertically scrolling lists with a large number of views. It ensures
/// consistent layout and performance with standard spacing and alignment.
///
/// > Note: `LazyVStack` is available on macOS 11.0+, iOS 14.0+, and other recent platforms.
///   On earlier platforms, this view will fall back to `VStack` without lazy loading.
/// 
/// ### Example:
/// ```swift
/// SxnnyLazyYStack(alignment: .center, spacing: 16) {
///     ForEach(items) { item in
///         ItemCell(item: item)
///     }
/// }
/// ```
public struct SxnnyLazyYStack<Content: View>: View {
    // MARK: Properties
    
    /// The horizontal alignment for the contents of the stack.
    private let alignment: HorizontalAlignment
    /// The spacing between adjacent views in the stack.
    private let spacing: CGFloat
    /// The content displayed within the lazy stack.
    private let content: () -> Content
    
    // MARK: Initialization
    
    /// Creates a lazy vertical stack with customizable alignment and spacing.
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
    
    /// The view’s body, rendering a vertically arranged, lazily loaded stack of views.
    public var body: some View {
        Group {
            if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                LazyVStack(alignment: alignment, spacing: spacing) {
                    content()
                }
            } else {
                VStack(alignment: alignment, spacing: spacing) {
                    content()
                }
            }
        }
    }
}
