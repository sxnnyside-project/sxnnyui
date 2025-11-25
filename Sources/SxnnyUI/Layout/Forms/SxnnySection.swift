//
//  SxnnySection.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnySection`, a convenient wrapper for SwiftUI’s `Section`
//  that applies standard insets and allows for optional custom headers. Use this to
//  ensure consistent section appearance and spacing throughout your app.
//
//  Usage Example:
//    SxnnySection(header: { Text("Profile") }) {
//        Text("User Details")
//    }
//

import SwiftUI

// MARK: - SxnnySection

/// A wrapper for SwiftUI's `Section` that applies SxnnyUI's standard insets and supports optional custom headers.
///
/// `SxnnySection` ensures consistent appearance and spacing for list or form sections,
/// with convenient header customization.
///
/// Example:
/// ```swift
/// SxnnySection(header: { Text("Settings") }) {
///     Toggle("Enable Feature", isOn: $isEnabled)
/// }
/// ```
public struct SxnnySection<Content: View, Header: View>: View {
    /// The optional header view displayed above the section content.
    private let header: Header?
    /// The content displayed inside the section.
    private let content: () -> Content

    /// Creates a section with optional custom header and standardized insets.
    ///
    /// - Parameters:
    ///   - content: A view builder providing the content of the section.
    ///   - header: A view builder providing an optional header for the section. Defaults to `nil`.
    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: () -> Header? = { nil }
    ) {
        self.header = header()
        self.content = content
    }

    /// The body of the section, applying consistent insets and custom header if provided.
    public var body: some View {
        if let header = header {
            Section(header: header) {
                content()
            }
            .listRowInsets(EdgeInsets(
                top: 8, leading: 16,
                bottom: 8, trailing: 16))
        } else {
            Section {
                content()
            }
            .listRowInsets(EdgeInsets(
                top: 8, leading: 16,
                bottom: 8, trailing: 16))
        }
    }
}
