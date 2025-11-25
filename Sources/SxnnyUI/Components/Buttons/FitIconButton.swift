//
//  FitIconButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  Deprecated: Use `SxnnyUI.IconButton` instead.
//  A button with a resizable icon and label, adapting gracefully to platform and size class.
//
//  Example usage:
//  ```swift
//  FitIconButton(
//      action: { print("Tapped!") },
//      iconName: "star.fill",
//      label: "Favorite",
//      isSelected: false
//  )
//  ```
//

import SwiftUI

/// A button with a resizable icon and label, adapting gracefully to platform and size class.
///
/// > Deprecated: Use `SxnnyUI.IconButton` instead.
///
/// - Parameters:
///   - action: Button action closure.
///   - iconName: The image name. Uses a bundled image if available, else falls back to SF Symbol.
///   - label: The button label text.
///   - isSelected: If true, applies selected style and overlay.
@available(*, deprecated, message: "Use SxnnyUI.IconButton instead")
@MainActor
public struct FitIconButton: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let action: () -> Void
    public let iconName: String
    public let label: String
    public let isSelected: Bool

    /// Creates a new `FitIconButton`.
    ///
    /// - Parameters:
    ///   - action: Button action closure.
    ///   - iconName: The image name. Uses a bundled image if available, else falls back to SF Symbol.
    ///   - label: The button label text.
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
        let buttonHeight: CGFloat = horizontalSizeClass == .compact ? 170 : 300
        let buttonMinHeight: CGFloat = horizontalSizeClass == .compact ? 145 : 200
        let iconSize: CGFloat = horizontalSizeClass == .compact ? 80 : 130
        let fontType: Font = horizontalSizeClass == .compact ? .body : .title

        Button(action: action) {
            VStack {
                PlatformFitIcon(name: iconName, iconSize: iconSize)
                Text(label)
                    .font(fontType)
                    .fontWeight(.black)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .applyFitIconButtonForegroundStyle()
        }
        .frame(maxWidth: buttonWidth, minHeight: buttonMinHeight, maxHeight: buttonHeight)
        .buttonStyle(.borderless)
        .applyFitIconButtonBackground(isSelected: isSelected)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 5, x: 0, y: 5)
        .overlay(isSelected ? FitIconButtonCheckmarkOverlay() : nil)
        .applyFitIconButtonForegroundStyle()
        // Accessibility (available on macOS 11+, iOS 14+)
        .applyFitIconButtonAccessibility(label: label)
    }
}

// MARK: - Cross-Platform Icon Loader

private struct PlatformFitIcon: View {
    let name: String
    let iconSize: CGFloat

    var body: some View {
        #if canImport(UIKit)
        if let uiImage = UIImage(named: name) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: iconSize)
        } else {
            FitSFSymbolIcon(name: name, iconSize: iconSize)
        }
        #else
        FitSFSymbolIcon(name: name, iconSize: iconSize)
        #endif
    }
}

private struct FitSFSymbolIcon: View {
    let name: String
    let iconSize: CGFloat

    var body: some View {
        Group {
            if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .frame(height: iconSize)
            } else if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: iconSize)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: iconSize)
            }
        }
    }
}

private struct FitIconButtonCheckmarkOverlay: View {
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
    /// Applies the button's background, supporting selection (package users should extend for custom gradients).
    @ViewBuilder
    func applyFitIconButtonBackground(isSelected: Bool) -> some View {
        if isSelected {
            self.background(Color.blue)
        } else {
            self.background(Color.accentColor)
        }
    }

    /// Applies a white foreground style if possible, else uses `.foregroundColor(.white)`.
    @ViewBuilder
    func applyFitIconButtonForegroundStyle() -> some View {
        if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
            self.foregroundStyle(.white)
        } else if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(Color.white)
        } else {
            self.foregroundColor(.white)
        }
    }

    /// Adds accessibility label if available on platform.
    @ViewBuilder
    func applyFitIconButtonAccessibility(label: String) -> some View {
        if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            self.accessibilityLabel(Text(label))
        } else {
            self
        }
    }
}
