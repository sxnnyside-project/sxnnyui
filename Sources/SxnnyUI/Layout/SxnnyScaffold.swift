//
//  SxnnyScaffold.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// Un contenedor estructural para pantallas que incluye barras superiores, inferiores, FABs y contenido.
/// Similar a Scaffold en Jetpack Compose.
public struct SxnnyScaffold<Content: View,
                            TopBar: View,
                            BottomBar: View,
                            FloatingActionButton: View>: View {
    
    private let content: Content
    private let topBar: TopBar
    private let bottomBar: BottomBar
    private let floatingActionButton: FloatingActionButton
    private let backgroundColor: Color
    private let useSafeArea: Bool
    
    public init(
        useSafeArea: Bool = true,
        backgroundColor: Color = SxnnyTheme.background,
        @ViewBuilder topBar: () -> TopBar = { EmptyView() },
        @ViewBuilder bottomBar: () -> BottomBar = { EmptyView() },
        @ViewBuilder floatingActionButton: () -> FloatingActionButton = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) {
        self.useSafeArea = useSafeArea
        self.backgroundColor = backgroundColor  
        self.topBar = topBar()
        self.bottomBar = bottomBar()
        self.floatingActionButton = floatingActionButton()
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                if useSafeArea {
                    content
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .modifier(SafeAreaBottomPadding())
                } else {
                    content
                }
                bottomBar
            }

            floatingActionButton
                .padding()
        }
    }
}
