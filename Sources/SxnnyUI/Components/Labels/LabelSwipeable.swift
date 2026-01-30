//
//  LabelSwipeable.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines a generic swipeable label/content view for SxnnyUI, with
//  platform and OS availability handling. APIs are documented for Swift package use.
//
//  Example usage:
//  ```swift
//  if #available(iOS 15.0, macOS 12.0, *) {
//      LabelSwipeable("New", systemImage: "star.fill") {
//          print("Swiped!")
//      }
//      .swipeEdge(.trailing)
//  }
//  ```
//

import SwiftUI

// MARK: - LabelSwipeable

/// A generic view that displays a label or custom content with a configurable swipe action.
/// Supports custom swipe edges via environment. Falls back gracefully on unsupported platforms.
///
/// > Note: Swipe actions require iOS 15.0+, macOS 12.0+, tvOS 15.0+, or watchOS 8.0+.
///
@MainActor
public struct LabelSwipeable<Content: View>: View {
    // MARK: Content & Action

    private let content: Content
    private let action: () -> Void

    // MARK: Environment

    @Environment(\.self) private var environment

    // MARK: Initializers

    @available(*, deprecated, message: "Use init(_ title: String, systemImage: String, action: @escaping () -> Void)")
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public init(icon: String, text: String, action: @escaping () -> Void) where Content == Label<Text, Image> {
        self.content = Label(text, systemImage: icon)
        self.action = action
    }

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public init(_ title: String, systemImage: String, action: @escaping () -> Void) where Content == Label<Text, Image> {
        self.content = Label(title, systemImage: systemImage)
        self.action = action
    }

    public init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.action = action
    }

    // MARK: View Body

    public var body: some View {
        Group {
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                content
                    .swipeActions(edge: swipeEdge, allowsFullSwipe: true) {
                        Button(action: action) {
                            SwipeableIcon()
                        }
                    }
            } else {
                content
            }
        }
    }

    // Only use HorizontalEdge and environment.swipeEdge when available
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    private var swipeEdge: HorizontalEdge {
        environment.swipeEdge
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @ViewBuilder
    private func SwipeableIcon() -> some View {
        Image(systemName: "plus.circle.fill")
            .tint(.green)
    }
}

// MARK: - Environment Key for Swipe Edge

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct SwipeEdgeKey: EnvironmentKey {
    static let defaultValue: HorizontalEdge = .leading
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {
    var swipeEdge: HorizontalEdge {
        get { self[SwipeEdgeKey.self] }
        set { self[SwipeEdgeKey.self] = newValue }
    }
}

// MARK: - Public API

public extension View {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func swipeEdge(_ edge: HorizontalEdge) -> some View {
        self.environment(\.swipeEdge, edge)
    }
}

