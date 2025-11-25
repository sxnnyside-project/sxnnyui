//
//  SxnnySafeAreaView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnySafeAreaView`, a reusable SwiftUI container for safely
//  presenting content while optionally ignoring specified safe area edges. Use this
//  view to control layout with respect to device notches, home indicators, or system bars.
//
//  Usage Example:
//    SxnnySafeAreaView(edgesToIgnore: [.bottom]) {
//        Text("Safe Area Demo")
//    }
//

import SwiftUI

// MARK: - SxnnySafeAreaView

/// A container view that safely presents content, optionally ignoring specified safe area edges.
///
/// Use `SxnnySafeAreaView` to control how content interacts with the system safe areas,
/// such as the notch, home indicator, or system bars. You can also apply extra padding if needed.
///
/// Example:
/// ```swift
/// SxnnySafeAreaView(edgesToIgnore: [.all], extraPadding: 16) {
///     VStack { Text("Full-bleed content") }
/// }
/// ```
public struct SxnnySafeAreaView<Content: View>: View {
    /// The set of edges where the safe area should be ignored.
    private let edgesToIgnore: Edge.Set
    /// Additional padding to apply to the content.
    private let extraPadding: CGFloat
    /// The content to be displayed inside the container.
    private let content: () -> Content

    /// Creates a safe area container for your content, with options to ignore specific edges and add extra padding.
    ///
    /// - Parameters:
    ///   - edgesToIgnore: The set of edges for which the safe area should be ignored. Defaults to an empty set (no edges ignored).
    ///   - extraPadding: Additional padding to apply inside the container. Defaults to `0`.
    ///   - content: A view builder that produces the content to display inside the container.
    public init(
        edgesToIgnore: Edge.Set = [],
        extraPadding: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.edgesToIgnore = edgesToIgnore
        self.extraPadding = extraPadding
        self.content = content
    }

    /// The view’s body, presenting the content with the specified safe area and padding configuration.
    public var body: some View {
        content()
            .padding(extraPadding)
            .edgesIgnoringSafeArea(edgesToIgnore)
    }
}
