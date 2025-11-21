//
//  SxnnyLazyYGrid.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnyLazyYGrid<Content: View>: View {
    private let columns: [GridItem]
    private let content: () -> Content

    public init(
        columns: [GridItem],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.columns = columns
        self.content = content
    }

    public var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: SxnnyTheme.defaultSpacing) {
                content()
            }
            .padding(SxnnyTheme.defaultPadding)
        }
    }
}
