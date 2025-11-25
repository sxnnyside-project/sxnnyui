//
//  TriggerButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 03/04/25.
//
//  A button that can perform a primary or secondary action based on its toggled state.
//  Adapts to all Apple platforms and OS versions, falling back gracefully on older systems.
//  Provides clear documentation and follows Swift package and API best practices.
//
//  Example usage:
//  ```swift
//  TriggerButton(
//      label: "Trigger Action",
//      action: { print("Primary") },
//      triggerAction: { print("Secondary") },
//      selected: true
//  )
//  ```
//

import SwiftUI

/// A toggleable button that switches between two actions and updates its label/icon accordingly.
///
/// - When `selected` is `true`, shows a label with a system image; otherwise, shows plain text.
/// - On tap, alternately calls `action` and `triggerAction`, toggling the icon each time.
/// - Adapts gracefully to platforms and OS versions lacking `Label` or SF Symbols.
///
/// - Parameters:
///   - label: The button label text.
///   - action: The primary action when the button is first tapped.
///   - triggerAction: The secondary action when tapped again.
///   - selected: If true, shows an icon; otherwise, shows plain text.
@MainActor
public struct TriggerButton: View {
    @State private var interactive: Bool = true
    @State private var labelIcon: String = "arrow.up"

    public let label: String
    public let action: () -> Void
    public let triggerAction: () -> Void
    private let selected: Bool

    /// Creates a new `TriggerButton`.
    ///
    /// - Parameters:
    ///   - label: The button label text.
    ///   - action: The primary action when the button is first tapped.
    ///   - triggerAction: The secondary action when tapped again.
    ///   - selected: If true, shows an icon; otherwise, shows plain text.
    public init(
        label: String,
        action: @escaping () -> Void,
        triggerAction: @escaping () -> Void,
        selected: Bool
    ) {
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
                labelIcon = "arrow.down"
            } else {
                triggerAction()
                interactive = true
                labelIcon = "arrow.up"
            }
        }) {
            ButtonLabelView(label: label, icon: labelIcon, showIcon: selected)
        }
    }
}

private struct ButtonLabelView: View {
    let label: String
    let icon: String
    let showIcon: Bool

    var body: some View {
        Group {
            if showIcon {
                if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                    Label(label, systemImage: icon)
                } else {
                    HStack {
                        // Only show icon where possible
                        if #available(macOS 11.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                            Image(systemName: icon)
                        }
                        Text(label)
                    }
                }
            } else {
                Text(label)
            }
        }
    }
}
