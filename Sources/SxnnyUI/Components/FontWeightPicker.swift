//
//  FontWeightPicker.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines types and views for selecting and managing font weights in SwiftUI.
//  All APIs are documented and guarded for platform compatibility, making them robust
//  for Swift package distribution.
//

import SwiftUI

// MARK: - Picker Styles

/// The style to use for the font weight picker.
///
/// Each style corresponds to a native picker style in SwiftUI. Not all styles are available
/// on every platform or OS version.
public enum FontWeightPickerStyle {
    /// A menu-style picker.
    case menu
    /// A wheel-style picker. (Not available on macOS.)
    case wheel
    /// A navigation link-style picker. (iOS 16.0+, not macOS.)
    case navigationLink
    /// A segmented control-style picker.
    case segmented
    /// An inline-style picker. (macOS 11.0+, iOS 14.0+)
    case inline
    /// A palette-style picker. (iOS 17.0+, macOS 14.0+)
    case palette
}

// MARK: - Font Weight Options

/// The available font weight choices for selection.
///
/// Use with `FontWeightPicker` and related types to control weight selection.
public enum FontWeightOptions: CaseIterable {
    /// Ultra-light font weight.
    case ultralight
    /// Thin font weight.
    case thin
    /// Light font weight.
    case light
    /// Regular font weight.
    case regular
    /// Medium font weight.
    case medium
    /// Semi-bold font weight.
    case semibold
    /// Bold font weight.
    case bold
    /// Heavy font weight.
    case heavy
    /// Black font weight.
    case black

    /// Returns the corresponding `Font.Weight`.
    public var fontWeight: Font.Weight {
        switch self {
        case .ultralight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
}

// MARK: - View Model

/// A view model that manages font weight selection for pickers.
public class FontWeightViewModel: ObservableObject {
    /// The currently selected `Font.Weight`.
    @Published public var selectedFontWeight: Font.Weight = .regular
    /// The currently selected font weight option.
    @Published public var selected: FontWeightOptions = .regular

    /// Creates a font weight view model.
    public init() {}
}

// MARK: - Default Font Weight Picker

/// A SwiftUI view for selecting from a fixed set of font weights.
///
/// This picker shows three weights (light, regular, bold) with visual SF Symbol icons
/// for each. Not available on all platforms—see availability notes.
///
/// Example usage:
/// ```swift
/// if #available(macOS 11.0, iOS 14.0, *) {
///     FontWeightPicker(fwViewModel: myViewModel)
/// }
/// ```
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public struct FontWeightPicker: View {
    /// The view model for selection.
    @ObservedObject private var fwViewModel: FontWeightViewModel

    /// The available font weights (light, regular, bold).
    private let fontWeights: [Font.Weight] = [.light, .regular, .bold]
    /// The system icons for each font weight.
    private let fontWeightIcons: [String] = ["textformat.size.smaller", "textformat.size", "textformat.size.larger"]

    /// Creates a font weight picker using the provided view model.
    /// - Parameter fwViewModel: The view model for selected font weight.
    public init(fwViewModel: FontWeightViewModel) {
        self.fwViewModel = fwViewModel
    }

    /// The body of the picker view.
    public var body: some View {
        Picker(selection: $fwViewModel.selectedFontWeight, label: Image(systemName: "textformat.size")) {
            ForEach(fontWeights.indices, id: \.self) { index in
                Image(systemName: fontWeightIcons[index])
                    .tag(fontWeights[index])
            }
        }
    }
}

// MARK: - Limited Font Weight Set

/// A structure representing a fixed set of font weight options.
///
/// Use to restrict pickers to 3 or 5 weights only.
public struct LimitedFontWeights {
    /// The font weight options.
    private let values: [FontWeightOptions]

    /// Creates a limited set of font weight options.
    ///
    /// - Parameter values: The allowed weights, must contain exactly 3 or 5 elements.
    public init(_ values: [FontWeightOptions]) {
        precondition(values.count == 3 || values.count == 5, "FontWeights must have exactly 3 or 5 elements.")
        self.values = values
    }

    /// The available font weight options.
    public var weights: [FontWeightOptions] { values }
}

// MARK: - Customizable Font Weight Picker

/// A SwiftUI view for selecting from a custom set of font weights.
///
/// This picker accepts up to 3 or 5 custom weights, each with a corresponding SF Symbol icon.
///
/// Example usage:
/// ```swift
/// FontWeightPickerCustom(
///     fwViewModel: myViewModel,
///     fontWeights: LimitedFontWeights([.light, .regular, .bold]),
///     fontWeightIcons: ["textformat.size.smaller", "textformat.size", "textformat.size.larger"]
/// )
/// ```
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public struct FontWeightPickerCustom: View {
    /// The view model for selection.
    @ObservedObject private var fwViewModel: FontWeightViewModel
    /// The limited set of font weights.
    private let fontWeights: LimitedFontWeights
    /// The system icons for each weight.
    private let fontWeightIcons: [String]

    /// Creates a custom font weight picker.
    ///
    /// - Parameters:
    ///   - fwViewModel: The view model for tracking selection.
    ///   - fontWeights: The allowed weights (3 or 5).
    ///   - fontWeightIcons: The SF Symbol icons for each weight.
    public init(
        fwViewModel: FontWeightViewModel,
        fontWeights: LimitedFontWeights = LimitedFontWeights([.light, .regular, .bold]),
        fontWeightIcons: [String] = ["textformat.size.smaller", "textformat.size", "textformat.size.larger"]
    ) {
        precondition(fontWeightIcons.count == fontWeights.weights.count, "fontWeightIcons array must match the number of fontWeights.")
        self.fwViewModel = fwViewModel
        self.fontWeights = fontWeights
        self.fontWeightIcons = fontWeightIcons
    }

    /// The body of the picker view.
    public var body: some View {
        Picker(selection: $fwViewModel.selected, label: Text("Font Weight")) {
            ForEach(fontWeights.weights.indices, id: \.self) { index in
                Image(systemName: fontWeightIcons[index])
                    .tag(fontWeights.weights[index])
            }
        }
    }
}

// MARK: - Picker Style Modifier

/// A view modifier for applying a specific picker style to a font weight picker.
///
/// Styles are only applied where supported on the running platform. Styles unavailable on the
/// current platform or OS are ignored.
public struct FontWeightPickerStyleModifier: ViewModifier {
    /// The style to apply.
    public let style: FontWeightPickerStyle

    public func body(content: Content) -> some View {
        Group {
            switch style {
            case .menu:
                if #available(macOS 11.0, iOS 14.0, *) {
                    content.pickerStyle(MenuPickerStyle())
                } else {
                    content
                }
            case .wheel:
                #if os(iOS) || os(tvOS) || os(watchOS)
                content.pickerStyle(WheelPickerStyle())
                #else
                content
                #endif
            case .navigationLink:
                #if os(iOS)
                if #available(iOS 16.0, *) {
                    content.pickerStyle(NavigationLinkPickerStyle())
                } else {
                    content
                }
                #else
                content
                #endif
            case .segmented:
                content.pickerStyle(SegmentedPickerStyle())
            case .inline:
                if #available(macOS 11.0, iOS 14.0, *) {
                    content.pickerStyle(InlinePickerStyle())
                } else {
                    content
                }
            case .palette:
                if #available(macOS 14.0, iOS 17.0, *) {
                    content.pickerStyle(PalettePickerStyle())
                } else {
                    content
                }
            }
        }
    }
}

// MARK: - Public API

public extension View {
    /// Applies a style to a font weight picker.
    ///
    /// Example usage:
    /// ```swift
    /// FontWeightPicker(fwViewModel: myViewModel)
    ///     .fontWeightPickerStyle(.segmented)
    /// ```
    ///
    /// - Parameter style: The style to apply.
    /// - Returns: The picker view with the specified style applied, if supported.
    func fontWeightPickerStyle(_ style: FontWeightPickerStyle) -> some View {
        self.modifier(FontWeightPickerStyleModifier(style: style))
    }
}
