//
//  LabeledIconButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  Deprecated: Use `SxnnyUI.IconButton` instead.
//  A button with a large icon, label, and optional footnote—adapts gracefully to platform and size class.
//
//  Example usage:
//  ```swift
//  LabeledIconButton(
//      action: { print("Tapped!") },
//      iconName: "star.fill",
//      label: "Favorite",
//      footnote: "Tap to select",
//      isSelected: false
//  )
//  ```
//

import SwiftUI

/// A button with an icon, label, and footnote—adapting gracefully to platform and size class.
///
/// > Deprecated: Use `SxnnyUI.IconButton` instead.
///
/// - Parameters:
///   - action: Button action closure.
///   - iconName: The image name. Uses a bundled image if available, else falls back to SF Symbol.
///   - label: The main label text.
///   - footnote: The footnote or subtitle text.
///   - isSelected: If true, applies selected style and overlay.
@available(iOS 16.0, *)
@available(*, deprecated, message: "Use SxnnyUI.IconButton instead")
@MainActor
public struct LabeledIconButton: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    public let action: () -> Void
    public let iconName: String
    public let label: String
    public let footnote: String
    public let isSelected: Bool

    /// Creates a new `LabeledIconButton`.
    ///
    /// - Parameters:
    ///   - action: Button action closure.
    ///   - iconName: The image name. Uses a bundled image if available, else falls back to SF Symbol.
    ///   - label: The main label text.
    ///   - footnote: The footnote or subtitle text.
    ///   - isSelected: If true, applies selected style and overlay.
    @available(*, deprecated, message: "Use SxnnyUI.IconButton instead")
    public init(
        action: @escaping () -> Void,
        iconName: String,
        label: String,
        footnote: String,
        isSelected: Bool
    ) {
        self.action = action
        self.iconName = iconName
        self.label = label
        self.footnote = footnote
        self.isSelected = isSelected
    }

    public var body: some View {
        let buttonWidth: CGFloat = horizontalSizeClass == .compact ? 150 : 400
        let buttonHeight: CGFloat = horizontalSizeClass == .compact ? 170 : 600

        Button(action: action) {
            LabeledIconButtonContent(
                iconName: iconName,
                label: label,
                footnote: footnote
            )
        }
        .frame(maxWidth: buttonWidth, minHeight: 145, maxHeight: buttonHeight)
        .buttonStyle(.borderless)
        .applyGradientBackground(isSelected: isSelected)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 5, x: 0, y: 5)
        .overlay(
            isSelected
            ? Group {
                if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                    Image(systemName: "checkmark.circle").offset(x: 50, y: -50)
                }
            } : nil
        )
        .applyForegroundStyle()
    }
}

// MARK: - Button Content View, Handles All Platform Restrictions

private struct LabeledIconButtonContent: View {
    let iconName: String
    let label: String
    let footnote: String

    var body: some View {
        Group {
            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                VStack(alignment: .center) {
                    PlatformIcon(name: iconName)
                    LabeledContent {
                        Text(footnote)
                            .fontDesign(.rounded)
                            .applyFootnoteForeground()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } label: {
                        Text(label)
                            .font(.body)
                            .fontWeight(.black)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                    .labeledContentStyle(.topLabeledStyle)
                }
            } else {
                // Fallback for older systems
                VStack(alignment: .center) {
                    PlatformIcon(name: iconName)
                    Text(label)
                        .font(.body)
                        .fontWeight(.black)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    Text(footnote)
                        .applyFootnoteForeground()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

// MARK: - Cross-Platform Icon Loader

private struct PlatformIcon: View {
    let name: String
    var body: some View {
        #if canImport(UIKit)
        if let uiImage = UIImage(named: name) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
        } else {
            SFSymbolIcon(name: name)
        }
        #else
        SFSymbolIcon(name: name)
        #endif
    }
}

private struct SFSymbolIcon: View {
    let name: String
    var body: some View {
        Group {
            if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .frame(height: 80)
            } else if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
            } else {
                // Fallback for even older platforms.
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 80)
            }
        }
    }
}

// MARK: - Style Helpers

private extension View {
    /// Applies a gradient background depending on selection.
    @ViewBuilder
    func applyGradientBackground(isSelected: Bool) -> some View {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.background(isSelected ? .selectedButtonGradient : .buttonGradient)
        } else {
            self.background(isSelected ? Color.gray : Color.blue)
        }
    }

    /// Applies a white foreground style where supported, else uses .foregroundColor(.white).
    @ViewBuilder
    func applyForegroundStyle() -> some View {
        if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
            self.foregroundStyle(.white)
        } else if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(Color.white)
        } else {
            self.foregroundColor(.white)
        }
    }

    /// Applies a gray footnote style where supported, else uses .foregroundColor(.gray).
    @ViewBuilder
    func applyFootnoteForeground() -> some View {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(Color.gray)
        } else {
            self.foregroundColor(.gray)
        }
    }
}
