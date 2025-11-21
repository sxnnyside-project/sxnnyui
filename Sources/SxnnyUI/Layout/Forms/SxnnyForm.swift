//
//  SxnnyForm.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// Wrapper personalizado para `Form` que aplica estilos y configuraciones base de SxnnyUI.
public struct SxnnyForm<Content: View>: View {
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        Form {
            content()
        }
        .accentColor(SxnnyTheme.accentColor) // Ejemplo: aplica color base del framework
        .environment(\.defaultMinListRowHeight, 44) // Puedes personalizar filas
        .padding(SxnnyTheme.defaultPadding)
    }
}
