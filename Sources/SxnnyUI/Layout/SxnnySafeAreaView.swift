//
//  SxnnySafeAreaView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnySafeAreaView<Content: View>: View {
    private let edgesToIgnore: Edge.Set
    private let content: () -> Content
    private let extraPadding: CGFloat

    public init(
        edgesToIgnore: Edge.Set = [],
        extraPadding: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.edgesToIgnore = edgesToIgnore
        self.extraPadding = extraPadding
        self.content = content
    }

    public var body: some View {
        content()
            .padding(extraPadding)
            .edgesIgnoringSafeArea(edgesToIgnore)
    }
}
