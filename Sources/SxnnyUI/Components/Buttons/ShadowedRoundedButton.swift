//
//  ShadowedRoundedButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

@available(*, deprecated, message: "Use SxnnyUI.RoundedButton instead")
public struct ShadowedRoundedButton: View {
    public let label: String
    public let systemImage: String
    public let backgroundColor: Color
    public let action: () -> Void
    public let asyncAction: () async -> Void
    public let disabled: Bool
    private let voidStyle: VoidStyle
    
    private enum VoidStyle {
        case sync
        case async
    }
    
    public init(label: String, systemImage: String, backgroundColor: Color, disabled: Bool = false, action: @escaping () -> Void) {
        self.label = label
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.action = action
        self.disabled = disabled
        self.asyncAction = { }
        self.voidStyle = .sync
    }
    
    public init(label: String, systemImage: String, backgroundColor: Color, disabled: Bool = false, action: @escaping () async -> Void) {
        self.label = label
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.asyncAction = action
        self.disabled = disabled
        self.action = { }
        self.voidStyle = .async
    }
    
    public var body: some View {
        Button(action: executeAction) {
            if #available(iOS 16.0, *) {
                Label(label, systemImage: systemImage)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(disabled ? Color.gray : backgroundColor)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
            } else {
                Label(label, systemImage: systemImage)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(disabled ? Color.gray : backgroundColor)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
            }
        }
        .disabled(disabled)
        .buttonStyle(.borderless)
    }
    
    private func executeAction() {
        switch voidStyle {
        case .sync:
            action()
        case .async:
            Task {
                await asyncAction()
            }
        }
    }
}
