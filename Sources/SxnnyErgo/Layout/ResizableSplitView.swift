//
//  ResizableSplitView.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

// MARK: - ResizableSplitView
//
// Arranges two views with a user-draggable divider, handling ratio clamping and drag
// gesture tracking correctly. `NavigationSplitView` does not cover this case — it
// manages navigation columns, not an arbitrary draggable ratio split between two views.
// The divider tracks the pointer 1:1 during a drag and exposes an adjustable
// accessibility element for VoiceOver users.

/// A resizable split view that arranges two views with a user-draggable divider,
/// supporting horizontal or vertical orientation.
///
/// Use `ResizableSplitView` for layouts where users adjust the proportion of space
/// between two panels — editors, inspectors, master/detail panes.
///
/// ```swift
/// ResizableSplitView(
///     axis: .horizontal,
///     minSplit: 0.3,
///     maxSplit: 0.7,
///     first: { SidebarView() },
///     second: { DetailView() }
/// )
/// ```
public struct ResizableSplitView<First: View, Second: View>: View {
    @State private var splitRatio: CGFloat
    private let axis: Axis
    private let minSplit: CGFloat
    private let maxSplit: CGFloat
    private let dividerThickness: CGFloat
    private let dividerColor: Color
    private let first: () -> First
    private let second: () -> Second

    /// Creates a resizable split view with two content areas and a draggable divider.
    ///
    /// - Parameters:
    ///   - axis: `.horizontal` arranges the panes side-by-side with a vertical divider;
    ///     `.vertical` stacks them with a horizontal divider. Defaults to `.horizontal`.
    ///   - initialSplit: The starting ratio (0–1) of space given to `first`. Defaults to `0.5`.
    ///   - minSplit: The minimum ratio (0–1) of space given to `first`. Defaults to `0.2`.
    ///   - maxSplit: The maximum ratio (0–1) of space given to `first`. Defaults to `0.8`.
    ///   - dividerThickness: The width (for `.horizontal`) or height (for `.vertical`)
    ///     of the draggable divider. Defaults to `8`.
    ///   - dividerColor: The color of the divider. Defaults to `.secondary`.
    ///   - first: A view builder for the first (leading/top) pane.
    ///   - second: A view builder for the second (trailing/bottom) pane.
    public init(
        axis: Axis = .horizontal,
        initialSplit: CGFloat = 0.5,
        minSplit: CGFloat = 0.2,
        maxSplit: CGFloat = 0.8,
        dividerThickness: CGFloat = 8,
        dividerColor: Color = .secondary,
        @ViewBuilder first: @escaping () -> First,
        @ViewBuilder second: @escaping () -> Second
    ) {
        self._splitRatio = State(initialValue: min(max(minSplit, initialSplit), maxSplit))
        self.axis = axis
        self.minSplit = minSplit
        self.maxSplit = maxSplit
        self.dividerThickness = dividerThickness
        self.dividerColor = dividerColor
        self.first = first
        self.second = second
    }

    public var body: some View {
        GeometryReader { geo in
            switch axis {
            case .horizontal:
                HStack(spacing: 0) {
                    first()
                        .frame(width: geo.size.width * splitRatio)
                    divider(dimension: geo.size.width, isHorizontal: true)
                    second()
                        .frame(width: geo.size.width * (1 - splitRatio))
                }
            case .vertical:
                VStack(spacing: 0) {
                    first()
                        .frame(height: geo.size.height * splitRatio)
                    divider(dimension: geo.size.height, isHorizontal: false)
                    second()
                        .frame(height: geo.size.height * (1 - splitRatio))
                }
            }
        }
    }

    @ViewBuilder
    private func divider(dimension: CGFloat, isHorizontal: Bool) -> some View {
        Divider()
            .background(dividerColor)
            .frame(
                width: isHorizontal ? dividerThickness : nil,
                height: isHorizontal ? nil : dividerThickness
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let location = isHorizontal ? value.location.x : value.location.y
                        let newRatio = location / dimension
                        splitRatio = min(max(minSplit, newRatio), maxSplit)
                    }
            )
            .accessibilityLabel(Text("Divider"))
            .accessibilityValue(Text("\(Int(splitRatio * 100))%"))
            .accessibilityAddTraits(.isButton)
            .accessibilityAdjustableAction { direction in
                let step: CGFloat = 0.05
                switch direction {
                case .increment:
                    splitRatio = min(splitRatio + step, maxSplit)
                case .decrement:
                    splitRatio = max(splitRatio - step, minSplit)
                @unknown default:
                    break
                }
            }
    }
}
