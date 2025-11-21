//
//  FillIconButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

@available(*, deprecated, message: "Use SxnnyUI.IconButton instead")
public struct FillIconButton: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    public let action: () -> Void
    public let iconName: String
    public let label: String
    public let isSelected: Bool

    @available(*, deprecated, message: "Use SxnnyUI.IconButton instead")
    public init(action: @escaping () -> Void, iconName: String, label: String, isSelected: Bool) {
        self.action = action
        self.iconName = iconName
        self.label = label
        self.isSelected = isSelected
    }
    
    public var body: some View {
        let buttonWidth: CGFloat = horizontalSizeClass == .compact ? 150 : 400
        let buttonHeight: CGFloat = horizontalSizeClass == .compact ? 170 : 370
        let buttonMinHeight: CGFloat = horizontalSizeClass == .compact ? 145 : 200
        let fontColor: Color = horizontalSizeClass == .compact ? .black : .clear
        
        Button(action: action) {
            VStack {
                if let uiImage = UIImage(named: iconName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 80)
                } else {
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .symbolRenderingMode(.hierarchical)
                        .frame(height: 80)
                }
                Text(label)
                    .font(.body)
                    .fontWeight(.black)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(fontColor)
        }
        .frame(maxWidth: buttonWidth, minHeight: buttonMinHeight, maxHeight: buttonHeight)
        .buttonStyle(.borderless)
        .background(isSelected ? .selectedButtonGradient : .buttonGradient)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 5, x: 0, y: 5)
        .overlay(isSelected ? Image(systemName: "checkmark.circle").offset(x: 50, y: -50) : nil)
        .foregroundStyle(.white)
    }
}
