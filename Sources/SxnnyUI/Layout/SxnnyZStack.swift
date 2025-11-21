//
//  SxnnyZStack.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// Un `ZStack` personalizado que permite especificar alineación y contenido,
/// con estilo y espaciado consistente basado en el tema del framework.
public struct SxnnyZStack<Content: View>: View {
    private let alignment: Alignment
    private let content: () -> Content

    public init(
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: alignment) {
            content()
        }
        // Puedes añadir aquí estilos comunes para ZStack, por ejemplo:
        // .padding(SxnnyTheme.defaultPadding)
        // .background(SxnnyTheme.backgroundColor)
    }
}
