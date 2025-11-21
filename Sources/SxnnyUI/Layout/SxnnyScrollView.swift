//
//  SxnnyScrollView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnyScrollView<Content: View>: View {
    public enum Axis {
        case vertical, horizontal, both
    }

    private let axis: Axis
    private let showsIndicators: Bool
    private let content: () -> Content

    public init(
        axis: Axis = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content
    }

    public var body: some View {
        switch axis {
        case .vertical:
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                content()
                    .padding(SxnnyTheme.defaultPadding)
            }
        case .horizontal:
            ScrollView(.horizontal, showsIndicators: showsIndicators) {
                content()
                    .padding(SxnnyTheme.defaultPadding)
            }
        case .both:
            ScrollView([.horizontal, .vertical], showsIndicators: showsIndicators) {
                content()
                    .padding(SxnnyTheme.defaultPadding)
            }
        }
    }
}
