//
//  SxnnySplitView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnySplitView`, a resizable split view container that arranges
//  two child views either horizontally or vertically, separated by a draggable divider.
//  Use this for adaptive layouts that support user-driven resizing.
//
//  Usage Example:
//    SxnnySplitView(
//        axis: .horizontal,
//        leftView: { SidebarView() },
//        rightView: { ContentView() }
//    )
//

import SwiftUI

// MARK: - SxnnySplitView

/// A resizable split view that arranges two child views with a draggable divider,
/// supporting horizontal or vertical orientation.
///
/// Use `SxnnySplitView` for layouts where users can adjust the proportion of space
/// between two panels, such as editors, dashboards, or sidebars.
///
/// Example:
/// ```swift
/// SxnnySplitView(
///     axis: .vertical,
///     minSplit: 0.3,
///     maxSplit: 0.7,
///     leftView: { MasterView() },
///     rightView: { DetailView() }
/// )
/// ```
public struct SxnnySplitView<Left: View, Right: View>: View {
    /// The orientation of the split: horizontal (side-by-side) or vertical (stacked).
    public enum Axis {
        case horizontal, vertical
    }

    /// The current ratio (0–1) that determines the space allocated to the first view.
    @State private var splitRatio: CGFloat = 0.5
    /// The split orientation.
    private let axis: Axis
    /// The minimum allowed split ratio.
    private let minSplit: CGFloat
    /// The maximum allowed split ratio.
    private let maxSplit: CGFloat
    /// A view builder for the first (left/top) child view.
    private let leftView: () -> Left
    /// A view builder for the second (right/bottom) child view.
    private let rightView: () -> Right

    /// Creates a resizable split view with two content areas and a draggable divider.
    ///
    /// - Parameters:
    ///   - axis: The orientation of the split: `.horizontal` for side-by-side, `.vertical` for stacked. Defaults to horizontal.
    ///   - minSplit: The minimum ratio (0–1) of space given to the first view. Defaults to `0.2`.
    ///   - maxSplit: The maximum ratio (0–1) of space given to the first view. Defaults to `0.8`.
    ///   - leftView: A view builder for the first (left/top) child view.
    ///   - rightView: A view builder for the second (right/bottom) child view.
    public init(
        axis: Axis = .horizontal,
        minSplit: CGFloat = 0.2,
        maxSplit: CGFloat = 0.8,
        @ViewBuilder leftView: @escaping () -> Left,
        @ViewBuilder rightView: @escaping () -> Right
    ) {
        self.axis = axis
        self.minSplit = minSplit
        self.maxSplit = maxSplit
        self.leftView = leftView
        self.rightView = rightView
    }

    /// The content and layout of the split view, including the draggable divider.
    public var body: some View {
        GeometryReader { geo in
            if axis == .horizontal {
                HStack(spacing: 0) {
                    leftView()
                        .frame(width: geo.size.width * splitRatio)
                    Divider()
                        .background(Color.secondary)
                        .frame(width: 8)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newRatio = value.location.x / geo.size.width
                                    splitRatio = min(max(minSplit, newRatio), maxSplit)
                                }
                        )
                    rightView()
                        .frame(width: geo.size.width * (1 - splitRatio))
                }
            } else {
                VStack(spacing: 0) {
                    leftView()
                        .frame(height: geo.size.height * splitRatio)
                    Divider()
                        .background(Color.secondary)
                        .frame(height: 8)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newRatio = value.location.y / geo.size.height
                                    splitRatio = min(max(minSplit, newRatio), maxSplit)
                                }
                        )
                    rightView()
                        .frame(height: geo.size.height * (1 - splitRatio))
                }
            }
        }
        .animation(.easeInOut, value: splitRatio)
    }
}
