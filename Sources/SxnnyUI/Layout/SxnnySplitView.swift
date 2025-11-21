//
//  SxnnySplitView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnySplitView<Left: View, Right: View>: View {
    public enum Axis {
        case horizontal, vertical
    }

    @State private var splitRatio: CGFloat = 0.5
    private let axis: Axis
    private let minSplit: CGFloat
    private let maxSplit: CGFloat
    private let leftView: () -> Left
    private let rightView: () -> Right

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
                                    let newRatio = (value.location.x / geo.size.width)
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
                                    let newRatio = (value.location.y / geo.size.height)
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
