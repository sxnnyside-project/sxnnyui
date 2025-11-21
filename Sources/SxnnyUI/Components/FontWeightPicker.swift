//
//  FontWeightViewModel.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// An enumeration representing different styles for the `FontWeightPicker`.
public enum FontWeightPickerStyle {
    /// A menu-style picker.
    case menu
    /// A wheel-style picker.
    case wheel
    /// A navigation link-style picker.
    case navigationLink
    /// A segmented control-style picker.
    case segmented
    /// An inline-style picker.
    case inline
    /// A palette-style picker (iOS 17.0+).
    case palette
}

/// An enumeration representing the available font weight options.
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

    /// The corresponding `Font.Weight` for the font weight option.
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

/// A view model for managing the selected font weight.
public class FontWeightViewModel: ObservableObject {
    /// The currently selected `Font.Weight`.
    @Published public var selectedFontWeight: Font.Weight = .regular
    /// The currently selected `FontWeightOptions`.
    @Published public var selected: FontWeightOptions = .regular

    /// Initializes a new instance of `FontWeightViewModel`.
    public init() {}
}

/// A SwiftUI view for selecting a font weight using a picker.
public struct FontWeightPicker: View {
    /// The view model that manages the selected font weight.
    @ObservedObject private var fwViewModel: FontWeightViewModel

    /// The available font weights for selection.
    private let fontWeights: [Font.Weight] = [.light, .regular, .bold]
    /// The system icons corresponding to each font weight.
    private let fontWeightIcons: [String] = ["textformat.size.smaller", "textformat.size", "textformat.size.larger"]

    /// Initializes a new instance of `FontWeightPicker`.
    /// - Parameter fwViewModel: The view model that manages the selected font weight.
    public init(fwViewModel: FontWeightViewModel) {
        self.fwViewModel = fwViewModel
    }

    /// The body of the `FontWeightPicker` view.
    /// Displays a picker with font weight options and their corresponding icons.
    public var body: some View {
        Picker(selection: $fwViewModel.selectedFontWeight, label: Image(systemName: "textformat.size")) {
            ForEach(fontWeights.indices, id: \.self) { index in
                Image(systemName: fontWeightIcons[index])
                    .tag(fontWeights[index])
            }
        }
    }
}

/// A structure representing a limited set of font weight options.
public struct LimitedFontWeights {
    /// The font weight options.
    private let values: [FontWeightOptions]

    /// Initializes a new instance of `LimitedFontWeights`.
    /// - Parameter values: The font weight options (must contain exactly 3 or 5 elements).
    public init(_ values: [FontWeightOptions]) {
        precondition(values.count == 3 || values.count == 5, "FontWeights must have exactly 3 or 5 elements.")
        self.values = values
    }

    /// The available font weight options.
    public var weights: [FontWeightOptions] {
        values
    }
}

/// A SwiftUI view for selecting a custom set of font weights using a picker.
public struct FontWeightPickerCustom: View {
    /// The view model that manages the selected font weight.
    @ObservedObject private var fwViewModel: FontWeightViewModel
    /// The limited set of font weight options.
    private let fontWeights: LimitedFontWeights
    /// The system icons corresponding to each font weight.
    private let fontWeightIcons: [String]

    /// Initializes a new instance of `FontWeightPickerCustom`.
    /// - Parameters:
    ///   - fwViewModel: The view model that manages the selected font weight.
    ///   - fontWeights: The limited set of font weight options.
    ///   - fontWeightIcons: The system icons corresponding to each font weight.
    public init(
        fwViewModel: FontWeightViewModel,
        fontWeights: LimitedFontWeights = LimitedFontWeights([.light, .regular, .bold]),
        fontWeightIcons: [String] = ["textformat.size.smaller", "textformat.size", "textformat.size.larger"]
    ) {
        guard fontWeightIcons.count == fontWeights.weights.count else {
            fatalError("fontWeightIcons array must match the number of fontWeights.")
        }

        self.fwViewModel = fwViewModel
        self.fontWeights = fontWeights
        self.fontWeightIcons = fontWeightIcons
    }

    /// The body of the `FontWeightPickerCustom` view.
    /// Displays a picker with custom font weight options and their corresponding icons.
    public var body: some View {
        Picker(selection: $fwViewModel.selected, label: Text("Font Weight")) {
            ForEach(fontWeights.weights.indices, id: \.self) { index in
                Image(systemName: fontWeightIcons[index])
                    .tag(fontWeights.weights[index])
            }
        }
    }
}

/// A view modifier for applying a specific style to a `FontWeightPicker`.
public struct FontWeightPickerStyleModifier: ViewModifier {
    /// The style to apply to the picker.
    public let style: FontWeightPickerStyle

    /// Modifies the content view based on the selected style.
    public func body(content: Content) -> some View {
        switch style {
        case .menu:
            content.pickerStyle(MenuPickerStyle())
        case .wheel:
            content.pickerStyle(WheelPickerStyle())
        case .navigationLink:
            if #available(iOS 16.0, *) {
                content.pickerStyle(NavigationLinkPickerStyle())
            }
        case .segmented:
            content.pickerStyle(SegmentedPickerStyle())
        case .inline:
            content.pickerStyle(InlinePickerStyle())
        case .palette:
            if #available(iOS 17.0, *) {
                content.pickerStyle(PalettePickerStyle())
            }
        }
    }
}

extension View {
    /// Applies a specific style to a `FontWeightPicker`.
    /// - Parameter style: The style to apply.
    /// - Returns: A view with the specified picker style applied.
    public func fontWeightPickerStyle(_ style: FontWeightPickerStyle) -> some View {
        self.modifier(FontWeightPickerStyleModifier(style: style))
    }
}
