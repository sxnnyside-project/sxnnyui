//
//  LabelSwipeable.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// A custom view that displays a label or custom content with swipeable actions.
/// The swipe action is configured to appear on the leading edge with a green "plus" icon.
public struct LabelSwipeable<Content: View>: View {
    /// The content of the view, which can be a `Label` or any custom view.
    private let content: Content
    /// The action to perform when the swipe action is triggered.
    private let action: () -> Void
    /// The swipe edge, configurable via the environment.
    @Environment(\.swipeEdge) private var swipeEdge


    /// Initializes a `LabelSwipeable` with a deprecated initializer.
    /// - Parameters:
    ///   - icon: The name of the system image to display in the label.
    ///   - text: The text to display in the label.
    ///   - action: The action to perform when the swipe action is triggered.
    @available(*, deprecated, message: "Use init(_ title: String, systemImage: String, action: @escaping () -> Void)")
    public init(icon: String, text: String, action: @escaping () -> Void) where Content == Label<Text, Image> {
        self.content = Label(text, systemImage: icon)
        self.action = action
    }

    /// Initializes a `LabelSwipeable` with a title and system image.
    /// - Parameters:
    ///   - title: The text to display in the label.
    ///   - systemImage: The name of the system image to display in the label.
    ///   - action: The action to perform when the swipe action is triggered.
    public init(_ title: String, systemImage: String, action: @escaping () -> Void) where Content == Label<Text, Image> {
        self.content = Label(title, systemImage: systemImage)
        self.action = action
    }

    /// Initializes a `LabelSwipeable` with custom content.
    /// - Parameters:
    ///   - action: The action to perform when the swipe action is triggered.
    ///   - content: A closure that provides the custom content for the view.
    public init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.action = action
    }

    /// The body of the `LabelSwipeable` view.
    /// Displays the content with a swipe action configured on the leading edge.
    public var body: some View {
        content
            .swipeActions(
                edge: swipeEdge,
                allowsFullSwipe: true
            ) {
                Button(action: action) {
                    Image(systemName: "plus.circle.fill")
                        .tint(.green)
                }
            }
    }
}

/// A custom environment key to specify the swipe edge.
private struct SwipeEdgeKey: EnvironmentKey {
    static let defaultValue: HorizontalEdge = .leading
}

extension EnvironmentValues {
    /// The swipe edge for the `SwipeableModifier`.
    var swipeEdge: HorizontalEdge {
        get { self[SwipeEdgeKey.self] }
        set { self[SwipeEdgeKey.self] = newValue }
    }
}

extension View {
    /// Sets the swipe edge for the view.
    /// - Parameter edge: The `HorizontalEdge` to use for swipe actions.
    /// - Returns: A view with the specified swipe edge set in the environment.
    public func swipeEdge(_ edge: HorizontalEdge) -> some View {
        self.environment(\.swipeEdge, edge)
    }
}
