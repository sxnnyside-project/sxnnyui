//
//  TriggerButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 03/04/25.
//

import SwiftUI

public struct TriggerButton: View {
    @State private var interactive: Bool = true
    @State private var LabelIcon: String = "arrow.up"
    
    public var label: String
    public let action: () -> Void
    public let triggerAction: () -> Void
    private let selected: Bool
    
    public init(label: String, action: @escaping () -> Void, triggerAction: @escaping () -> Void, selected: Bool) {
        self.label = label
        self.action = action
        self.triggerAction = triggerAction
        self.selected = selected
    }
    
    public var body: some View {
        Button(action: {
            if interactive {
                action()
                interactive = false
                LabelIcon = "arrow.down"
            } else {
                triggerAction()
                interactive = true
                LabelIcon = "arrow.up"
            }
        }, label: {
            if !selected {
                Text(label)
            } else {
                Label(label, systemImage: LabelIcon)
            }
        })
    }
}
