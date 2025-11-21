//
//  ValidationButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 01/04/25.
//

import SwiftUI

@available(iOS 16.0, *)
public struct ValidationButton: View {
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
        labelTitle: String = "Presiona para verificar",
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
        
        Button(action: {
            if validationAction() {
                destination()
            }
        }, label: {
            Label(labelTitle, systemImage: labelIcon)
                .fontWeight(labelFontWeight)
                .controlSize(labelControlSize)
                .padding(.vertical, labelPadding)
                .labelStyle(.titleAndIcon)
                .frame(maxWidth: .infinity)
            
        })
        .buttonStyle(.borderedProminent)
        .tint(buttonTint)
    }
}
