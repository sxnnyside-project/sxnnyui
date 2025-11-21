//
//  SxnnyOverlay.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnyOverlay<Content: View>: View {
    @Binding private var isPresented: Bool
    private let content: () -> Content

    public init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
    }

    public var body: some View {
        GeometryReader { geo in
            if isPresented {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isPresented = false
                            }
                        }

                    content()
                        .frame(maxWidth: geo.size.width * 0.8,
                               maxHeight: geo.size.height * 0.5)
                        .background(SxnnyTheme.background)
                        .cornerRadius(16)
                        .shadow(radius: 20)
                        .transition(.scale.combined(with: .opacity))
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}
