//
//  SxnnyGrid.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyGrid`, a convenience wrapper for SwiftUI’s `LazyVGrid`
//  for displaying grid-based layouts. Use this view to arrange content in a
//  customizable grid with a standard spacing.
//
//  Usage Example:
//    SxnnyGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
//        ForEach(items) { item in
//            ItemView(item: item)
//        }
//    }
//

import SwiftUI

// MARK: - SxnnyGrid

/// A convenience grid view for displaying content in columns with standard spacing.
///
/// `SxnnyGrid` wraps SwiftUI’s `LazyVGrid` to provide convenient, consistent
/// vertical grid layouts.
///
/// Example:
/// ```swift
/// SxnnyGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
///     ForEach(0..<10) { i in
///         Text("Item \(i)")
///     }
/// }
/// ```
@available(macOS 11.0, iOS 14.0, *)
public struct SxnnyGrid<Content: View>: View {
    /// The configuration for each grid column.
    private let columns: [GridItem]
    /// The content to display within the grid.
    private let content: () -> Content

    /// Creates a grid with the specified columns and content.
    ///
    /// - Parameters:
    ///   - columns: An array of `GridItem` describing the column layout.
    ///   - content: A view builder providing the content of the grid.
    public init(
        columns: [GridItem],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.columns = columns
        self.content = content
    }

    /// The view’s body, rendering the grid with standard spacing between items.
    public var body: some View {
        LazyVGrid(columns: columns, spacing: SxnnyTheme.defaultSpacing) {
            content()
        }
    }
}
