//
//  FlowLayout.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 14/07/26.
//
//  This file defines `FlowLayout`, a `Layout` that arranges subviews left-to-right,
//  wrapping to a new row whenever the next subview would overflow the available width.
//  It is the missing container for tag lists, chip groups, and similar wrapping content
//  (for example, a row of `TokenView` or `Badge` instances) — content that SwiftUI's
//  built-in stacks cannot wrap on their own.
//

import SwiftUI

// MARK: - FlowLayout

/// A layout that arranges its subviews in left-to-right rows, wrapping to a new row
/// when the next subview would overflow the available width.
///
/// `FlowLayout` is the natural container for tag lists and chip groups — content whose
/// item count and widths aren't known ahead of time, such as a collection of
/// `TokenView` or `Badge` views.
///
/// ```swift
/// FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
///     ForEach(tags) { tag in
///         TokenView(id: tag.id, text: tag.name) { removeTag($0) }
///     }
/// }
/// ```
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct FlowLayout: Layout {
    /// The horizontal gap between subviews on the same row.
    public var horizontalSpacing: CGFloat

    /// The vertical gap between rows.
    public var verticalSpacing: CGFloat

    /// The horizontal alignment of subviews within each row.
    public var alignment: HorizontalAlignment

    /// Creates a flow layout.
    ///
    /// - Parameters:
    ///   - horizontalSpacing: The horizontal gap between subviews on the same row. Defaults to `8`.
    ///   - verticalSpacing: The vertical gap between rows. Defaults to `8`.
    ///   - alignment: The horizontal alignment of subviews within each row. Defaults to `.leading`.
    public init(
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        alignment: HorizontalAlignment = .leading
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.alignment = alignment
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = Self.arrangeRows(
            subviews: subviews,
            maxWidth: maxWidth,
            horizontalSpacing: horizontalSpacing
        )

        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        for (index, row) in rows.enumerated() {
            totalWidth = max(totalWidth, row.width)
            totalHeight += row.height
            if index < rows.count - 1 {
                totalHeight += verticalSpacing
            }
        }
        return CGSize(width: totalWidth, height: totalHeight)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let maxWidth = bounds.width
        let rows = Self.arrangeRows(
            subviews: subviews,
            maxWidth: maxWidth,
            horizontalSpacing: horizontalSpacing
        )

        var y = bounds.minY
        for row in rows {
            let leftover = bounds.width - row.width
            let rowOriginX: CGFloat
            switch alignment {
            case .trailing:
                rowOriginX = bounds.minX + leftover
            case .center:
                rowOriginX = bounds.minX + leftover / 2
            default:
                rowOriginX = bounds.minX
            }

            var x = rowOriginX
            for item in row.items {
                let size = item.size
                item.subview.place(
                    at: CGPoint(x: x, y: y),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(size)
                )
                x += size.width + horizontalSpacing
            }
            y += row.height + verticalSpacing
        }
    }

    // MARK: - Row Arrangement

    private struct RowItem {
        let subview: LayoutSubview
        let size: CGSize
    }

    private struct Row {
        var items: [RowItem] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private static func arrangeRows(
        subviews: Subviews,
        maxWidth: CGFloat,
        horizontalSpacing: CGFloat
    ) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row()

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let additionalWidth =
                currentRow.items.isEmpty
                ? size.width
                : horizontalSpacing + size.width

            if !currentRow.items.isEmpty, currentRow.width + additionalWidth > maxWidth {
                rows.append(currentRow)
                currentRow = Row()
                currentRow.items.append(RowItem(subview: subview, size: size))
                currentRow.width = size.width
                currentRow.height = size.height
            } else {
                currentRow.items.append(RowItem(subview: subview, size: size))
                currentRow.width += additionalWidth
                currentRow.height = max(currentRow.height, size.height)
            }
        }

        if !currentRow.items.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }
}
