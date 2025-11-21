//
//  SxnnyXStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// Un `HStack` con espaciado y alineación por defecto definidos por el tema.
public struct SxnnyXStack<Content: View>: View {
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
        HStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
}
