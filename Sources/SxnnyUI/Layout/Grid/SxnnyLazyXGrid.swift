//
//  SxnnyLazyXGrid.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyLazyXGrid`, a horizontally scrolling grid view using SwiftUI's
//  `LazyHGrid`. Use this for efficient, horizontally-scrolling layouts with flexible row configurations.
//
//  Usage Example:
//    SxnnyLazyXGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60))]) {
//        ForEach(items) { item in
//            ItemView(item: item)
//        }
//    }
//

import SwiftUI

// MARK: - SxnnyLazyXGrid

/// A horizontally scrolling, efficient grid view built on SwiftUI's `LazyHGrid`.
///
/// `SxnnyLazyXGrid` arranges its content in rows, inside a horizontal scroll view,
/// allowing for flexible, performant layouts with row configuration and spacing.
///
/// Example:
/// ```swift
/// SxnnyLazyXGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60))]) {
///     ForEach(0..<10) { i in
///         Text("Item \(i)")
///     }
/// }
/// ```
@available(macOS 11.0, iOS 14.0, *)
public struct SxnnyLazyXGrid<Content: View>: View {
    /// The configuration for each grid row.
    private let rows: [GridItem]
    /// The content to display within the grid.
    private let content: () -> Content

    /// Creates a horizontally scrolling grid with the specified row configuration.
    ///
    /// - Parameters:
    ///   - rows: An array of `GridItem` describing the layout of each row.
    ///   - content: A view builder providing the content of the grid.
    public init(
        rows: [GridItem],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rows = rows
        self.content = content
    }

    /// The view’s body, rendering a `LazyHGrid` in a horizontal scroll view with standard padding and spacing.
    public var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: SxnnyTheme.defaultSpacing) {
                content()
            }
            .padding(SxnnyTheme.defaultPadding)
        }
    }
}
