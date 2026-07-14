//
//  EqualSizeLayout.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 14/07/26.
//
//  This file defines `EqualSizeLayout`, a `Layout` that sizes every subview to match
//  the largest proposed size among its siblings, along a configurable axis. It replaces
//  the manual `PreferenceKey` plumbing typically required to make, for example, a row of
//  buttons all as wide as the widest one.
//

import SwiftUI

// MARK: - EqualSizeLayout

/// A layout that sizes every subview to the maximum size among its siblings, along a
/// configurable set of axes.
///
/// Use `EqualSizeLayout` when you need uniformly sized children without manually
/// measuring them via a `PreferenceKey` — for example, a row of buttons that should all
/// be as wide as the widest one.
///
/// ```swift
/// EqualSizeLayout(matching: .horizontal) {
///     Button("OK") { }
///     Button("Cancel") { }
///     Button("Learn More") { }
/// }
/// ```
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct EqualSizeLayout: Layout {
    /// The axes along which subviews are equalized. Defaults to `.horizontal`.
    public var matching: Axis.Set

    /// Creates an equal-size layout.
    ///
    /// - Parameter matching: The axes to equalize. Pass `.horizontal`, `.vertical`, or
    ///   `[.horizontal, .vertical]` to equalize both width and height. Defaults to `.horizontal`.
    public init(matching: Axis.Set = .horizontal) {
        self.matching = matching
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        guard !subviews.isEmpty else { return .zero }

        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxSize = Self.maxSize(of: sizes)

        var totalWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        for size in sizes {
            let width = matching.contains(.horizontal) ? maxSize.width : size.width
            let height = matching.contains(.vertical) ? maxSize.height : size.height
            totalWidth += width
            totalHeight = max(totalHeight, height)
        }
        return CGSize(width: totalWidth, height: totalHeight)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        guard !subviews.isEmpty else { return }

        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxSize = Self.maxSize(of: sizes)

        var x = bounds.minX
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            let width = matching.contains(.horizontal) ? maxSize.width : size.width
            let height = matching.contains(.vertical) ? maxSize.height : size.height
            subview.place(
                at: CGPoint(x: x, y: bounds.minY),
                anchor: .topLeading,
                proposal: ProposedViewSize(width: width, height: height)
            )
            x += width
        }
    }

    private static func maxSize(of sizes: [CGSize]) -> CGSize {
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        for size in sizes {
            maxWidth = max(maxWidth, size.width)
            maxHeight = max(maxHeight, size.height)
        }
        return CGSize(width: maxWidth, height: maxHeight)
    }
}
