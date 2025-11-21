//
//  SxnnySection.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// Wrapper para `Section` con personalización base para encabezados y contenido.
public struct SxnnySection<Content: View, Header: View>: View {
    private let header: Header?
    private let content: () -> Content

    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: () -> Header? = { nil }
    ) {
        self.header = header()
        self.content = content
    }

    public var body: some View {
        if let header = header {
            Section(header: header) {
                content()
            }
            .listRowInsets(EdgeInsets(
                top: 8, leading: 16,
                bottom: 8, trailing: 16))
        } else {
            Section {
                content()
            }
            .listRowInsets(EdgeInsets(
                top: 8, leading: 16,
                bottom: 8, trailing: 16))
        }
    }
}
