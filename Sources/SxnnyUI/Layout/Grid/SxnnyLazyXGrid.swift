//
//  SxnnyLazyXGrid.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnyLazyXGrid<Content: View>: View {
    private let rows: [GridItem]
    private let content: () -> Content

    public init(
        rows: [GridItem],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rows = rows
        self.content = content
    }

    public var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: SxnnyTheme.defaultSpacing) {
                content()
            }
            .padding(SxnnyTheme.defaultPadding)
        }
    }
}
