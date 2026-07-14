//
//  BreakpointLayout.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

// MARK: - BreakpointLayout
//
// Chooses between fundamentally different layouts based on available width (compact
// list vs. multi-column grid, sidebar vs. tab bar) without scattering `GeometryReader`
// and manual width comparisons through the view hierarchy. The produced content always
// fills the space `BreakpointLayout` is given, so it behaves predictably inside parent
// stacks.

/// A container view that selects between differently-shaped content based on the
/// available horizontal width.
///
/// Use `BreakpointLayout` where a view's *structure* — not just its styling — needs to
/// change with available space: a sidebar appearing only above a certain width, a grid
/// collapsing to a single column, or a compact toolbar becoming a full one.
///
/// ```swift
/// BreakpointLayout(
///     small: { CompactListView() },
///     medium: { TwoColumnView() },
///     large: { ThreeColumnView() }
/// )
/// ```
///
/// For the common two-tier case, use the convenience initializer:
///
/// ```swift
/// BreakpointLayout(breakpoint: 600, compact: { PhoneLayout() }, regular: { PadLayout() })
/// ```
public struct BreakpointLayout<Small: View, Medium: View, Large: View>: View {

    /// The width thresholds that separate small, medium, and large content.
    public struct Breakpoints: Sendable, Equatable {
        /// Widths below this value use the `small` content. Defaults to `400`.
        public var medium: CGFloat
        /// Widths at or above this value use the `large` content; widths between
        /// `medium` and `large` use the `medium` content. Defaults to `800`.
        public var large: CGFloat

        /// Creates a set of width breakpoints.
        ///
        /// - Parameters:
        ///   - medium: The width at or above which content moves from `small` to
        ///     `medium`. Defaults to `400`.
        ///   - large: The width at or above which content moves from `medium` to
        ///     `large`. Defaults to `800`.
        public init(medium: CGFloat = 400, large: CGFloat = 800) {
            self.medium = medium
            self.large = large
        }
    }

    private let breakpoints: Breakpoints
    private let small: () -> Small
    private let medium: () -> Medium
    private let large: () -> Large

    /// Creates a layout that chooses among three content builders based on width.
    ///
    /// - Parameters:
    ///   - breakpoints: The width thresholds separating small, medium, and large.
    ///     Defaults to `Breakpoints()` (400 / 800 points).
    ///   - small: Content shown when width is below `breakpoints.medium`.
    ///   - medium: Content shown when width is between `breakpoints.medium` and
    ///     `breakpoints.large`.
    ///   - large: Content shown when width is at or above `breakpoints.large`.
    public init(
        breakpoints: Breakpoints = Breakpoints(),
        @ViewBuilder small: @escaping () -> Small,
        @ViewBuilder medium: @escaping () -> Medium,
        @ViewBuilder large: @escaping () -> Large
    ) {
        self.breakpoints = breakpoints
        self.small = small
        self.medium = medium
        self.large = large
    }

    public var body: some View {
        GeometryReader { geo in
            Group {
                if geo.size.width < breakpoints.medium {
                    small()
                } else if geo.size.width < breakpoints.large {
                    medium()
                } else {
                    large()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

// MARK: - Two-Tier Convenience

extension BreakpointLayout where Medium == Large {
    /// Creates a two-tier layout that switches between `compact` and `regular` content
    /// at a single width threshold.
    ///
    /// This is the common case: most layouts only need to distinguish "narrow" from
    /// "wide," not three separate tiers.
    ///
    /// - Parameters:
    ///   - breakpoint: The width at or above which `regular` is shown instead of
    ///     `compact`. Defaults to `600`.
    ///   - compact: Content shown when width is below `breakpoint`.
    ///   - regular: Content shown when width is at or above `breakpoint`.
    public init(
        breakpoint: CGFloat = 600,
        @ViewBuilder compact: @escaping () -> Small,
        @ViewBuilder regular: @escaping () -> Medium
    ) {
        self.init(
            breakpoints: Breakpoints(medium: breakpoint, large: breakpoint),
            small: compact,
            medium: regular,
            large: regular
        )
    }
}
