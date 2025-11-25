//
//  SxnnyLazyYGrid.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyLazyYGrid`, a vertically scrolling grid view based on SwiftUI's
//  `LazyVGrid`. Use this to create efficient, scrollable vertical grid layouts with flexible
//  column configurations and standardized spacing and padding.
//
//  Usage Example:
//    SxnnyLazyYGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
//        ForEach(items) { item in
//            ItemView(item: item)
//        }
//    }
//

import SwiftUI

// MARK: - SxnnyLazyYGrid

/// A vertically scrolling, efficient grid view built on SwiftUI’s `LazyVGrid`.
///
/// `SxnnyLazyYGrid` arranges its content in columns, inside a vertical scroll view,
/// providing flexible, performant layouts with column configuration and spacing.
///
/// Example:
/// ```swift
/// SxnnyLazyYGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
///     ForEach(0..<10) { i in
///         Text("Item \(i)")
///     }
/// }
/// ```
@available(macOS 11.0, iOS 14.0, *)
public struct SxnnyLazyYGrid<Content: View>: View {
    /// The configuration for each grid column.
    private let columns: [GridItem]
    /// The content to display within the grid.
    private let content: () -> Content

    /// Creates a vertically scrolling grid with the specified column configuration.
    ///
    /// - Parameters:
    ///   - columns: An array of `GridItem` describing the layout of each column.
    ///   - content: A view builder providing the content of the grid.
    public init(
        columns: [GridItem],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.columns = columns
        self.content = content
    }

    /// The view’s body, rendering a `LazyVGrid` in a vertical scroll view with standard padding and spacing.
    public var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: SxnnyTheme.defaultSpacing) {
                content()
            }
            .padding(SxnnyTheme.defaultPadding)
        }
    }
}
