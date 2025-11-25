//
//  SxnnyResponsiveView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyResponsiveView`, a convenience view that selects among
//  three different content layouts based on available horizontal width. Use this
//  view to provide adaptive presentations for small, medium, and large screen sizes.
//
//  Usage Example:
//    SxnnyResponsiveView(
//        small: { Text("Small Layout") },
//        medium: { Text("Medium Layout") },
//        large: { Text("Large Layout") }
//    )
//

import SwiftUI

// MARK: - SxnnyResponsiveView

/// A container view that chooses between three layouts based on the current horizontal width.
///
/// Use `SxnnyResponsiveView` to provide distinct presentations for small, medium, and large devices
/// or window sizes. Width thresholds are set at 400 and 800 points by default.
///
/// Example:
/// ```swift
/// SxnnyResponsiveView(
///     small: { Text("For small screens") },
///     medium: { Text("For medium screens") },
///     large: { Text("For large screens") }
/// )
/// ```
public struct SxnnyResponsiveView<Small: View, Medium: View, Large: View>: View {
    /// The view to display on small screens (width < 400).
    private let small: () -> Small
    /// The view to display on medium screens (400 ≤ width < 800).
    private let medium: () -> Medium
    /// The view to display on large screens (width ≥ 800).
    private let large: () -> Large

    /// Creates a responsive container with custom layouts for small, medium, and large widths.
    ///
    /// - Parameters:
    ///   - small: A view builder for small widths (less than 400 points).
    ///   - medium: A view builder for medium widths (400–799 points).
    ///   - large: A view builder for large widths (800 points or more).
    public init(
        @ViewBuilder small: @escaping () -> Small,
        @ViewBuilder medium: @escaping () -> Medium,
        @ViewBuilder large: @escaping () -> Large
    ) {
        self.small = small
        self.medium = medium
        self.large = large
    }

    /// Chooses and displays the appropriate content based on the current horizontal size.
    public var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            Group {
                if width < 400 {
                    small()
                } else if width < 800 {
                    medium()
                } else {
                    large()
                }
            }
        }
    }
}
