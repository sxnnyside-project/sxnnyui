//
//  ShapeGradient.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//


import SwiftUI

extension ShapeStyle where Self == LinearGradient {
    public static var buttonGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.9, green: 0.9, blue: 0.9),
                Color(red: 1.0, green: 1.0, blue: 0.95)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    public static var selectedButtonGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.green.opacity(0.2),
                Color.green.opacity(0.6)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    public static var blueTextGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.accentColor,
                Color(hex: "#88D9D0")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static var greenTextGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.green,
                Color.green.opacity(0.6)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static var blackTextGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color.gray
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static var invertblackTextGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color.gray
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }
    
    public static var whiteTextGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color.gray
            ]),
            startPoint: .topLeading,
            endPoint: .bottomLeading
        )
    }
    
    public static var invertwhiteTextGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color.gray
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomTrailing
        )
    }
    
    public static var invertpinkTextGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.red.opacity(0.8),
                Color.pink
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }
    
    public static var bluebackgroundGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#BDEEFB").opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    @available(macOS 12.0, iOS 15.0, *)
    public static var indigobackgroundGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.indigo.opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    public static var pinkbackgroundGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color.pink.opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    public static var graybackgroundGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#F0F0F0").opacity(0.8),
                Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
