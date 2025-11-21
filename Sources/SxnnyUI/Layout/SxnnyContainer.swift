//
//  SxnnyContainer.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnyContainer<Content: View>: View {
    private let content: () -> Content
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let padding: CGFloat

    public init(
        backgroundColor: Color = SxnnyTheme.background,
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 5,
        padding: CGFloat = SxnnyTheme.defaultPadding,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.padding = padding
        self.content = content
    }

    public var body: some View {
        content()
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
}
