//
//  ShapeGradient.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file provides a set of predefined gradients as static properties on `ShapeStyle`
//  for use throughout SxnnyUI. These gradients are designed for consistent, accessible,
//  and visually appealing backgrounds or foregrounds in SwiftUI. Each gradient is
//  suitable for common UI components such as buttons, text, and surfaces.
//
//  Usage Example:
//    .background(.buttonGradient)
//    .foregroundStyle(.blueTextGradient)
//

import SwiftUI

// MARK: - Predefined Gradients for Common UI Elements

/// Commonly used gradients for UI components in SxnnyUI.
/// Provides consistent background and foreground styles for buttons, text, and surfaces.
@MainActor
public extension ShapeStyle where Self == LinearGradient {

    // MARK: - Button Gradients

    /// A subtle light vertical gradient for button backgrounds, from light gray to off-white.
    static var buttonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.9, green: 0.9, blue: 0.9),
                Color(red: 1.0, green: 1.0, blue: 0.95)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// A green-tinted vertical gradient for emphasizing selected button states.
    static var selectedButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.green.opacity(0.2),
                Color.green.opacity(0.6)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Text Gradients

    /// A blue diagonal gradient for text, from accent color to a custom blue-green.
    static var blueTextGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.accentColor,
                Color(hex: "#88D9D0")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// A green diagonal gradient for text, from standard green to a lighter green.
    static var greenTextGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.green,
                Color.green.opacity(0.6)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// A diagonal gradient for text, from black to gray.
    static var blackTextGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color.gray
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// A mirrored version of `blackTextGradient`, with the gradient reversed horizontally.
    static var invertblackTextGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color.gray
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }
    
    /// A diagonal gradient for text, from white to gray.
    static var whiteTextGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color.gray
            ]),
            startPoint: .topLeading,
            endPoint: .bottomLeading
        )
    }
    
    /// A mirrored version of `whiteTextGradient`, with the gradient reversed horizontally.
    static var invertwhiteTextGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color.gray
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomTrailing
        )
    }
    
    /// An inverted diagonal gradient for text, from red toward pink.
    static var invertpinkTextGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.red.opacity(0.8),
                Color.pink
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }
    
    // MARK: - Background Gradients

    /// A soft blue vertical background gradient, fading to clear.
    static var bluebackgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#BDEEFB").opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// An indigo vertical background gradient, fading to clear.
    ///
    /// - Availability: macOS 12.0, iOS 15.0, and later.
    @available(macOS 12.0, iOS 15.0, *)
    static var indigobackgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.indigo.opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// A pink vertical background gradient, fading to clear.
    static var pinkbackgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.pink.opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// A light gray vertical background gradient, fading to clear.
    static var graybackgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#F0F0F0").opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
