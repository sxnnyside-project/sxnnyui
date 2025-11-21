//
//  SxnnyLazyXStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// Un `LazyHStack` con espaciado y alineación por defecto, ideal para listas horizontales grandes.
public struct SxnnyLazyXStack<Content: View>: View {
    private let alignment: VerticalAlignment
    private let spacing: CGFloat
    private let content: () -> Content

    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat = SxnnyTheme.defaultSpacing,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        LazyHStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
}
