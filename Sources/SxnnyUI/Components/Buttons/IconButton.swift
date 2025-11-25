//
//  IconButton.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 31/03/25.
//
//  A customizable button with icon and label, adapting gracefully to platform and OS version differences.
//  Supports custom gradients and accessibility. See documentation for extension points.
//
//  Example usage:
//  ```swift
//  IconButton(iconName: "star.fill", label: "Favorite") { print("Tapped!") }
//      .iconButtonGradient(LinearGradient(...))
//  ```
//

import SwiftUI

// MARK: - IconButton

/// A configurable button with icon and label, supporting builder and convenience initializers.
///
/// - Features:
///   - Custom icons (SF Symbols or asset images) and text labels.
///   - Supports accessibility, gradients, and adaptive layout.
///   - Graceful fallback for unavailable APIs/platforms.
///
/// Availability:
/// - macOS 10.15+, iOS 13.0+, tvOS 13.0+, watchOS 6.0+ (with style/features safely degrading)
public struct IconButton<Icon: View, Label: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // MARK: - Internal Properties

    private let action: () -> Void
    private let iconName: String
    private let label: String
    private let iconContent: Icon
    private let labelContent: Label
    private let additional: String?
    private let contentMode: ContentMode
    private let isSelected: Bool
    private let cornerRadius: CGFloat
    private let gradient: LinearGradient?
    private let shadowColor: Color
    private let bodyType: BodyType

    private enum BodyType { case simple, custom }

    // MARK: - Initializers

    /// Creates an `IconButton` with an SF Symbol or asset icon and string label.
    ///
    /// - Parameters:
    ///   - iconName: The SF Symbol or asset name for the icon.
    ///   - label: The main label text.
    ///   - additional: Optional subtitle or footnote.
    ///   - isSelected: Whether the button is in the selected state.
    ///   - contentMode: Icon's aspect ratio content mode. Defaults to `.fit`.
    ///   - cornerRadius: The button's corner radius. Defaults to `15`.
    ///   - gradient: The background gradient. Defaults to `nil` (package consumers can apply custom gradients with `.iconButtonGradient(...)`).
    ///   - shadowColor: Button shadow color. Defaults to `.gray`.
    ///   - action: The button action closure.
    public init(
        iconName: String,
        label: String,
        additional: String? = nil,
        isSelected: Bool = false,
        contentMode: ContentMode = .fit,
        cornerRadius: CGFloat = 15,
        gradient: LinearGradient? = nil,
        shadowColor: Color = .gray,
        action: @escaping () -> Void
    ) where Icon == AnyView, Label == AnyView {
        self.action = action
        self.iconName = iconName
        self.label = label
        self.iconContent = AnyView(IconButtonIcon(name: iconName, contentMode: contentMode))
        self.labelContent = AnyView(Text(label))
        self.additional = additional
        self.isSelected = isSelected
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.gradient = gradient
        self.shadowColor = shadowColor
        self.bodyType = .simple
    }

    /// Creates a fully custom `IconButton` with builder views for the icon and label.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the button is in the selected state.
    ///   - additional: Optional subtitle or footnote.
    ///   - contentMode: Icon's aspect ratio content mode. Defaults to `.fit`.
    ///   - cornerRadius: The button's corner radius.
    ///   - gradient: The background gradient. Defaults to `nil`.
    ///   - shadowColor: Button shadow color. Defaults to `.gray`.
    ///   - action: The button action closure.
    ///   - icon: View builder for the icon.
    ///   - label: View builder for the label.
    public init(
        isSelected: Bool = false,
        additional: String? = nil,
        contentMode: ContentMode = .fit,
        cornerRadius: CGFloat = 15,
        gradient: LinearGradient? = nil,
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

    // MARK: - Body

    public var body: some View {
        switch bodyType {
        case .simple:
            renderSimpleBody()
        case .custom:
            renderBuilderBody()
        }
    }

    // MARK: - Button Content Builders

    private func renderSimpleBody() -> some View {
        let w: CGFloat = horizontalSizeClass == .compact ? 150 : 400
        let h: CGFloat = horizontalSizeClass == .compact ? 170 : 300
        let minH: CGFloat = horizontalSizeClass == .compact ? 145 : 200
        let iconH: CGFloat = horizontalSizeClass == .compact ? 80 : 130
        let fontType: Font = horizontalSizeClass == .compact ? .body : .title

        return Button(action: action) {
            VStack {
                iconContent
                    .frame(height: iconH)
                if let additionalText = additional, !additionalText.isEmpty {
                    VStack {
                        Text(additionalText)
                            .applyIconButtonFootnoteStyle()
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
            .applyIconButtonForegroundStyle()
        }
        .buttonStyle(.borderless)
        .frame(maxWidth: w, minHeight: minH, maxHeight: h)
        .applyIconButtonBackground(isSelected: isSelected, gradient: gradient)
        .cornerRadius(cornerRadius)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
        .overlay(
            isSelected
            ? IconButtonCheckmarkOverlay()
            : nil
        )
        .applyIconButtonForegroundStyle()
        .applyIconButtonAccessibility(label: label, hint: additional)
    }

    private func renderBuilderBody() -> some View {
        let w: CGFloat = horizontalSizeClass == .compact ? 150 : 400
        let h: CGFloat = horizontalSizeClass == .compact ? 170 : 300
        let minH: CGFloat = horizontalSizeClass == .compact ? 145 : 200
        let iconH: CGFloat = horizontalSizeClass == .compact ? 80 : 130

        return Button(action: action) {
            VStack {
                iconContent
                    .frame(height: iconH)
                if let additionalText = additional, !additionalText.isEmpty {
                    VStack {
                        Text(additionalText)
                            .applyIconButtonFootnoteStyle()
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
            .applyIconButtonForegroundStyle()
        }
        .frame(maxWidth: w, minHeight: minH, maxHeight: h)
        .applyIconButtonBackground(isSelected: isSelected, gradient: gradient)
        .cornerRadius(cornerRadius)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
        .overlay(isSelected ? IconButtonCheckmarkOverlay() : nil)
        .applyIconButtonForegroundStyle()
    }
}

// MARK: - Cross-Platform Icon Loader

private struct IconButtonIcon: View {
    let name: String
    let contentMode: ContentMode

    var body: some View {
        #if canImport(UIKit)
        // Prefer asset, then SF Symbol (if available)
        if let uiImage = UIImage(named: name) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            SFSymbolIcon(name: name, contentMode: contentMode)
        }
        #else
        SFSymbolIcon(name: name, contentMode: contentMode)
        #endif
    }
}

private struct SFSymbolIcon: View {
    let name: String
    let contentMode: ContentMode
    var body: some View {
        Group {
            if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .symbolRenderingMode(.hierarchical)
            } else if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                // Fallback: show a gray rectangle
                Rectangle().fill(Color.gray)
            }
        }
    }
}

private struct IconButtonCheckmarkOverlay: View {
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

// MARK: - Gradient and Style Helpers

public extension View {
    /// Applies a gradient background to `IconButton`. Supply a fallback for older platforms.
    /// If you want to provide a package-wide custom gradient, define and apply it via this modifier.
    func iconButtonGradient(_ gradient: LinearGradient) -> some View {
        self.background(gradient)
    }
}

// Internal style helpers
private extension View {
    /// Applies the button's background, supporting selection and gradient customization.
    @ViewBuilder
    func applyIconButtonBackground(isSelected: Bool, gradient: LinearGradient?) -> some View {
        if let gradient = gradient {
            self.background(isSelected ? gradient : gradient)
        } else {
            self.background(isSelected ? Color.blue : Color.accentColor)
        }
    }

    /// Applies a white foreground style where possible; falls back to .foregroundColor(.white).
    @ViewBuilder
    func applyIconButtonForegroundStyle() -> some View {
        if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
            self.foregroundStyle(.white)
        } else if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(Color.white)
        } else {
            self.foregroundColor(.white)
        }
    }

    /// Applies a gray footnote style for subtitles/additional information.
    @ViewBuilder
    func applyIconButtonFootnoteStyle() -> some View {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(Color.gray)
        } else {
            self.foregroundColor(.gray)
        }
    }
    
    /// Applies accesibility label and hint for IconButton.
    @ViewBuilder
    func applyIconButtonAccessibility(label: String, hint: String?) -> some View {
        if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            self.accessibilityLabel(Text(label))
                .accessibilityHint(Text(hint ?? ""))
        } else {
            self
        }
    }
}
