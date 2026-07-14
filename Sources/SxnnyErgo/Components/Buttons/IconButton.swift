//
//  IconButton.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 31/03/25.
//

import SwiftUI

// MARK: - IconButton
//
// A large, tappable icon-over-label tile — the building block of quick-action grids,
// dashboard launchers, and settings-style icon menus. Handles adaptive sizing across
// size classes, a selected-state affordance, an SF-Symbol-or-asset icon fallback, and
// accessibility consistently, so it doesn't need to be rebuilt slightly differently in
// every app that needs it. Selection is communicated via a checkmark overlay, which
// composes correctly whether or not a custom background gradient is supplied.

/// A large, tappable tile combining an icon and a label — the building block of
/// quick-action grids, dashboard launchers, and icon-based menus.
///
/// ```swift
/// LazyVGrid(columns: columns) {
///     IconButton(iconName: "star.fill", label: "Favorite") { toggleFavorite() }
///     IconButton(iconName: "trash", label: "Delete", isSelected: isDeleting) { delete() }
/// }
/// ```
///
/// For fully custom icon or label content, use the builder initializer:
///
/// ```swift
/// IconButton(action: { share() }) {
///     Image(systemName: "square.and.arrow.up")
///         .symbolRenderingMode(.hierarchical)
/// } label: {
///     Text("Share").font(.headline)
/// }
/// ```
public struct IconButton<Icon: View, Label: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let action: () -> Void
    private let label: String
    private let iconContent: Icon
    private let labelContent: Label
    private let additional: String?
    private let isSelected: Bool
    private let cornerRadius: CGFloat
    private let gradient: LinearGradient?
    private let shadowColor: Color
    private let minWidth: CGFloat?
    private let maxWidth: CGFloat?
    private let minHeight: CGFloat?
    private let maxHeight: CGFloat?

    /// Creates an `IconButton` with an SF Symbol or asset icon and a string label.
    ///
    /// - Parameters:
    ///   - iconName: The SF Symbol or asset name for the icon.
    ///   - label: The main label text.
    ///   - additional: An optional subtitle or footnote shown above the label.
    ///   - isSelected: Whether the button is in the selected state. Selected buttons
    ///     display a checkmark overlay.
    ///   - contentMode: The icon's aspect ratio content mode. Defaults to `.fit`.
    ///   - cornerRadius: The button's corner radius. Defaults to `15`.
    ///   - gradient: An optional background gradient. Defaults to `nil`, which uses a
    ///     solid accent (or blue, when selected) background instead.
    ///   - shadowColor: The button's shadow color. Defaults to `.gray`.
    ///   - minWidth: Minimum button width. Defaults to a size-class-adaptive value.
    ///   - maxWidth: Maximum button width. Defaults to a size-class-adaptive value.
    ///   - minHeight: Minimum button height. Defaults to a size-class-adaptive value.
    ///   - maxHeight: Maximum button height. Defaults to a size-class-adaptive value.
    ///   - action: The button's action closure.
    public init(
        iconName: String,
        label: String,
        additional: String? = nil,
        isSelected: Bool = false,
        contentMode: ContentMode = .fit,
        cornerRadius: CGFloat = 15,
        gradient: LinearGradient? = nil,
        shadowColor: Color = .gray,
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        action: @escaping () -> Void
    ) where Icon == IconGlyph, Label == Text {
        self.action = action
        self.label = label
        self.iconContent = IconGlyph(name: iconName, contentMode: contentMode)
        self.labelContent = Text(label)
        self.additional = additional
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.gradient = gradient
        self.shadowColor = shadowColor
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }

    /// Creates a fully custom `IconButton` with builder views for the icon and label.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the button is in the selected state.
    ///   - additional: An optional subtitle or footnote shown above the label.
    ///   - cornerRadius: The button's corner radius. Defaults to `15`.
    ///   - gradient: An optional background gradient. Defaults to `nil`.
    ///   - shadowColor: The button's shadow color. Defaults to `.gray`.
    ///   - minWidth: Minimum button width. Defaults to a size-class-adaptive value.
    ///   - maxWidth: Maximum button width. Defaults to a size-class-adaptive value.
    ///   - minHeight: Minimum button height. Defaults to a size-class-adaptive value.
    ///   - maxHeight: Maximum button height. Defaults to a size-class-adaptive value.
    ///   - action: The button's action closure.
    ///   - icon: A view builder for the icon.
    ///   - label: A view builder for the label.
    public init(
        isSelected: Bool = false,
        additional: String? = nil,
        cornerRadius: CGFloat = 15,
        gradient: LinearGradient? = nil,
        shadowColor: Color = .gray,
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = ""
        self.iconContent = icon()
        self.labelContent = label()
        self.additional = additional
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.gradient = gradient
        self.shadowColor = shadowColor
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }

    public var body: some View {
        let iconHeight: CGFloat = horizontalSizeClass == .compact ? 80 : 130

        Button(action: action) {
            VStack {
                iconContent
                    .frame(height: iconHeight)
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
            .foregroundStyle(.white)
        }
        .buttonStyle(.borderless)
        .frame(
            minWidth: minWidth,
            maxWidth: maxWidth ?? (horizontalSizeClass == .compact ? 150 : 400),
            minHeight: minHeight ?? (horizontalSizeClass == .compact ? 145 : 200),
            maxHeight: maxHeight ?? (horizontalSizeClass == .compact ? 170 : 300)
        )
        .background(gradient.map { AnyShapeStyle($0) } ?? AnyShapeStyle(isSelected ? Color.blue : Color.accentColor))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
        .overlay {
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(.white)
                    .offset(x: 50, y: -50)
            }
        }
        .accessibilityLabel(Text(label.isEmpty ? "Icon button" : label))
        .accessibilityHint(Text(additional ?? ""))
    }
}

// MARK: - Icon Glyph

/// Resolves an icon by name, preferring a bundled asset image and falling back to an
/// SF Symbol.
public struct IconGlyph: View {
    let name: String
    let contentMode: ContentMode

    public var body: some View {
        #if canImport(UIKit)
            if let uiImage = UIImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .symbolRenderingMode(.hierarchical)
            }
        #else
            Image(systemName: name)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .symbolRenderingMode(.hierarchical)
        #endif
    }
}
