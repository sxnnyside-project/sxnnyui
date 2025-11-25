//
//  FillIconButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  Deprecated: Use `SxnnyUI.IconButton` instead.
//  A button with a fill-aspect icon and label, fully adaptive for all Apple platforms and OS versions.
//
//  Example usage:
//  ```swift
//  FillIconButton(
//      action: { print("Tapped!") },
//      iconName: "star.fill",
//      label: "Favorite",
//      isSelected: false
//  )
//  ```
//

import SwiftUI

/// A button with a fill-aspect icon and label, adapting to platform and OS version.
///
/// > Deprecated: Use `SxnnyUI.IconButton` instead.
///
/// - Parameters:
///   - action: The button action closure.
///   - iconName: The image/SF Symbol name.
///   - label: The main label text.
///   - isSelected: If true, applies selected style and overlay.
@available(*, deprecated, message: "Use SxnnyUI.IconButton instead")
@MainActor
public struct FillIconButton: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let action: () -> Void
    public let iconName: String
    public let label: String
    public let isSelected: Bool

    /// Creates a new `FillIconButton`.
    ///
    /// - Parameters:
    ///   - action: The button action closure.
    ///   - iconName: The image/SF Symbol name.
    ///   - label: The main label text.
    ///   - isSelected: If true, applies selected style and overlay.
    @available(*, deprecated, message: "Use SxnnyUI.IconButton instead")
    public init(
        action: @escaping () -> Void,
        iconName: String,
        label: String,
        isSelected: Bool
    ) {
        self.action = action
        self.iconName = iconName
        self.label = label
        self.isSelected = isSelected
    }

    public var body: some View {
        let buttonWidth: CGFloat = horizontalSizeClass == .compact ? 150 : 400
        let buttonHeight: CGFloat = horizontalSizeClass == .compact ? 170 : 370
        let buttonMinHeight: CGFloat = horizontalSizeClass == .compact ? 145 : 200
        let iconSize: CGFloat = 80
        let fontColor: Color = horizontalSizeClass == .compact ? .black : .clear

        Button(action: action) {
            VStack {
                PlatformFillIcon(name: iconName, iconSize: iconSize)
                Text(label)
                    .font(.body)
                    .fontWeight(.black)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            }
            .applyFillIconButtonLabelColor(fontColor)
        }
        .frame(maxWidth: buttonWidth, minHeight: buttonMinHeight, maxHeight: buttonHeight)
        .buttonStyle(.borderless)
        .applyFillIconButtonBackground(isSelected: isSelected)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 5, x: 0, y: 5)
        .overlay(isSelected ? FillIconButtonCheckmarkOverlay() : nil)
        .applyFillIconButtonForegroundStyle()
    }
}

// MARK: - Cross-Platform Icon Loader

private struct PlatformFillIcon: View {
    let name: String
    let iconSize: CGFloat

    var body: some View {
        #if canImport(UIKit)
        if let uiImage = UIImage(named: name) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: iconSize)
        } else {
            FillSFSymbolIcon(name: name, iconSize: iconSize)
        }
        #else
        FillSFSymbolIcon(name: name, iconSize: iconSize)
        #endif
    }
}

private struct FillSFSymbolIcon: View {
    let name: String
    let iconSize: CGFloat

    var body: some View {
        Group {
            if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .symbolRenderingMode(.hierarchical)
                    .frame(height: iconSize)
            } else if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: iconSize)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: iconSize)
            }
        }
    }
}

private struct FillIconButtonCheckmarkOverlay: View {
    var body: some View {
        Group {
            if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Image(systemName: "checkmark.circle").offset(x: 50, y: -50)
            } else {
                EmptyView()
            }
        }
    }
}

// MARK: - Style Helpers

private extension View {
    /// Applies foreground color to button label as appropriate for platform/OS.
    @ViewBuilder
    func applyFillIconButtonLabelColor(_ color: Color) -> some View {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(color)
        } else {
            self.foregroundColor(color)
        }
    }

    /// Applies white foreground style if possible, else falls back to `.white`.
    @ViewBuilder
    func applyFillIconButtonForegroundStyle() -> some View {
        if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
            self.foregroundStyle(.white)
        } else if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(Color.white)
        } else {
            self.foregroundColor(.white)
        }
    }

    /// Applies the button's background (extend in your package for gradients).
    @ViewBuilder
    func applyFillIconButtonBackground(isSelected: Bool) -> some View {
        if isSelected {
            self.background(Color.blue)
        } else {
            self.background(Color.accentColor)
        }
    }
}
