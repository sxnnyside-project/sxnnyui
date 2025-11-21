//
//  SxnnyLazyYStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// Un `LazyVStack` personalizado con espaciado y alineación definidos por el tema.
public struct SxnnyLazyYStack<Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat
    private let content: () -> Content
    
    public init(
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = SxnnyTheme.defaultSpacing,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        LazyVStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
}
