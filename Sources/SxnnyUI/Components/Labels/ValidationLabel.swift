//
//  ValidationLabel.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//


import SwiftUI

@available(iOS 16.0, *)
public struct ValidationLabel: View {
    let destination: () -> Void
    let validationAction: () -> Bool
    let labelTitle: String
    let labelIcon: String
    let buttonTitle: String
    let buttonIcon: String
    var labelFontWeight: Font.Weight = .heavy
    var labelControlSize: ControlSize = .regular
    var labelPadding: CGFloat = 15
    var buttonTint: Color = .green

    public init(
        destination: @escaping () -> Void,
        validationAction: @escaping () -> Bool,
        labelTitle: String = "Desliza para verificar",
        labelIcon: String = "arrowtriangle.right.fill",
        buttonTitle: String = "Validar",
        buttonIcon: String = "checkmark.circle"
    ) {
        self.destination = destination
        self.validationAction = validationAction
        self.labelTitle = labelTitle
        self.labelIcon = labelIcon
        self.buttonTitle = buttonTitle
        self.buttonIcon = buttonIcon
    }

    public var body: some View {
        Label(labelTitle, systemImage: labelIcon)
            .fontWeight(labelFontWeight)
            .controlSize(labelControlSize)
            .padding(.vertical, labelPadding)
            .labelStyle(.titleAndIcon)
            .swipeActions(edge: .leading) {
                Button {
                    if validationAction() {
                        destination()
                    }
                } label: {
                    Label(buttonTitle, systemImage: buttonIcon)
                        .labelStyle(.iconOnly)
                }
                .tint(buttonTint)
            }
    }

    public func labelFontWeight(_ fontWeight: Font.Weight) -> ValidationLabel {
        var copy = self
        copy.labelFontWeight = fontWeight
        return copy
    }

    public func labelControlSize(_ controlSize: ControlSize) -> ValidationLabel {
        var copy = self
        copy.labelControlSize = controlSize
        return copy
    }

    public func labelPadding(_ padding: CGFloat) -> ValidationLabel {
        var copy = self
        copy.labelPadding = padding
        return copy
    }

    public func buttonTint(_ color: Color) -> ValidationLabel {
        var copy = self
        copy.buttonTint = color
        return copy
    }
}
