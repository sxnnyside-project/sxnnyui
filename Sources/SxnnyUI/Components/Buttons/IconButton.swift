//
//  IconButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 31/03/25.
//

import SwiftUI

public struct IconButton<Icon: View, Label: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    private let action: () -> Void
    private let iconName: String
    private let label: String
    private let iconContent: Icon
    private let labelContent: Label
    private let additional: String?
    private let contentMode: ContentMode
    private let isSelected: Bool
    private let cornerRadius: CGFloat
    private let gradient: LinearGradient
    private let shadowColor: Color
    private let bodyType: BodyType

    private enum BodyType {
        case simple
        case custom
    }

    public init(iconName: String,
                label: String,
                additional: String? = nil,
                isSelected: Bool = false,
                contentMode: ContentMode = .fit,
                cornerRadius: CGFloat = 15,
                gradient: LinearGradient = .buttonGradient,
                shadowColor: Color = .gray,
                action: @escaping () -> Void
    ) where Icon == Image, Label == Text {
        self.action = action
        self.iconName = iconName
        self.label = label
        self.iconContent = Image(systemName: iconName)
        self.labelContent = Text(label)
        self.additional = additional
        self.isSelected = isSelected
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.gradient = gradient
        self.shadowColor = shadowColor
        self.bodyType = .simple
    }
    
    public init(
        isSelected: Bool = false,
        additional: String? = nil,
        contentMode: ContentMode = .fit,
        cornerRadius: CGFloat = 15,
        gradient: LinearGradient = LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom),
        shadowColor: Color = .gray,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.iconName = ""
        self.label = ""
        self.iconContent = icon()
        self.labelContent = label()
        self.additional = additional
        self.isSelected = isSelected
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.gradient = gradient
        self.shadowColor = shadowColor
        self.bodyType = .custom
    }
    
    public var body: some View {
        switch bodyType {
        case .simple:
            renderSimpleBody()
        case .custom:
            renderBuilderBody()
        }
    }
    
    private func renderSimpleBody() -> some View {
        let buttonWidth: CGFloat = horizontalSizeClass == .compact ? 150 : 400
        let buttonHeight: CGFloat = horizontalSizeClass == .compact ? 170 : 300
        let buttonMinHeight: CGFloat = horizontalSizeClass == .compact ? 145 : 200
        let iconSize: CGFloat = horizontalSizeClass == .compact ? 80 : 130
        let fontType: Font = horizontalSizeClass == .compact ? .body : .title
        
        return Button(action: action) {
            VStack {
                if let uiImage = UIImage(named: iconName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(height: iconSize)
                } else {
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .symbolRenderingMode(.hierarchical)
                        .frame(height: iconSize)
                }
                
                if let additionalText = additional, !additionalText.isEmpty {
                    VStack {
                        Text(additionalText)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(label)
                            .font(fontType)
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    Text(label)
                        .font(fontType)
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.black)
        }
        .buttonStyle(.borderless)
        .frame(maxWidth: buttonWidth, minHeight: buttonMinHeight, maxHeight: buttonHeight)
        .background(isSelected ? .selectedButtonGradient : gradient)
        .cornerRadius(cornerRadius)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
        .overlay(isSelected ? Image(systemName: "checkmark.circle").offset(x: 50, y: -50) : nil)
        .foregroundStyle(.white)
        .accessibilityLabel(Text(label))
        .accessibilityHint(Text(additional ?? ""))
    }
    
    private func renderBuilderBody() -> some View {
        let buttonWidth: CGFloat = horizontalSizeClass == .compact ? 150 : 400
                let buttonHeight: CGFloat = horizontalSizeClass == .compact ? 170 : 300
                let buttonMinHeight: CGFloat = horizontalSizeClass == .compact ? 145 : 200
                let iconSize: CGFloat = horizontalSizeClass == .compact ? 80 : 130
        
        return Button(action: action) {
            VStack {
                iconContent
                    .frame(height: iconSize)

                if let additionalText = additional, !additionalText.isEmpty {
                    VStack {
                        Text(additionalText)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)

                        labelContent
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    labelContent
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.black)
        }
        .frame(maxWidth: buttonWidth, minHeight: buttonMinHeight, maxHeight: buttonHeight)
        .background(isSelected ? .selectedButtonGradient : gradient)
        .cornerRadius(cornerRadius)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
        .overlay(isSelected ? Image(systemName: "checkmark.circle").offset(x: 50, y: -50) : nil)
        .foregroundStyle(.white)
    }
}
