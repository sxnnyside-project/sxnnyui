//
//  SxnnyScrollView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyScrollView`, a wrapper for SwiftUI's `ScrollView` that
//  provides a convenient API for vertical, horizontal, or bidirectional scrolling,
//  with consistent padding and indicator options. Use this for flexible, standardized
//  scrolling layouts.
//
//  Usage Example:
//    SxnnyScrollView(axis: .both) {
//        MyContentView()
//    }
//

import SwiftUI

// MARK: - SxnnyScrollView

/// A scrollable container view supporting vertical, horizontal, or bidirectional scrolling.
///
/// `SxnnyScrollView` simplifies the use of SwiftUI's `ScrollView` by offering an easy way
/// to specify scrolling direction, show/hide scroll indicators, and automatically apply
/// standardized padding.
///
/// Example:
/// ```swift
/// SxnnyScrollView(axis: .vertical, showsIndicators: false) {
///     VStack { ... }
/// }
/// ```
public struct SxnnyScrollView<Content: View>: View {
    /// The scrolling direction(s) allowed.
    public enum Axis {
        /// Scroll only vertically.
        case vertical
        /// Scroll only horizontally.
        case horizontal
        /// Scroll both vertically and horizontally.
        case both
    }

    /// The axis or axes along which the content can scroll.
    private let axis: Axis
    /// Whether scroll indicators are visible.
    private let showsIndicators: Bool
    /// The content displayed within the scroll view.
    private let content: () -> Content

    /// Creates a scrollable container view.
    ///
    /// - Parameters:
    ///   - axis: The scroll direction(s) to allow. Defaults to `.vertical`.
    ///   - showsIndicators: Whether to show scroll indicators. Defaults to `true`.
    ///   - content: A view builder that provides the scroll view's content.
    public init(
        axis: Axis = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content
    }

    /// The view’s body—renders the content with the specified scroll axis and indicator setting.
    public var body: some View {
        switch axis {
        case .vertical:
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                content()
                    .padding(SxnnyTheme.defaultPadding)
            }
        case .horizontal:
            ScrollView(.horizontal, showsIndicators: showsIndicators) {
                content()
                    .padding(SxnnyTheme.defaultPadding)
            }
        case .both:
            ScrollView([.horizontal, .vertical], showsIndicators: showsIndicators) {
                content()
                    .padding(SxnnyTheme.defaultPadding)
            }
        }
    }
}
