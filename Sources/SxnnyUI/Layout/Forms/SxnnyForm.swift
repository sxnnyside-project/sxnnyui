//
//  SxnnyForm.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyForm`, a convenient wrapper for SwiftUI's `Form` that
//  applies SxnnyUI’s standard styles and layout settings. Use this to ensure consistent
//  form appearance and layout across your app.
//
//  Usage Example:
//    SxnnyForm {
//        Section(header: Text("User Info")) {
//            TextField("Name", text: $name)
//            Toggle("Notifications", isOn: $notificationsEnabled)
//        }
//    }
//

import SwiftUI

// MARK: - SxnnyForm

/// A convenient wrapper for SwiftUI’s `Form` that applies SxnnyUI’s standard colors, row heights, and padding.
///
/// `SxnnyForm` ensures consistent appearance and layout for forms within your app.
///
/// Example:
/// ```swift
/// SxnnyForm {
///     Section(header: Text("Details")) {
///         TextField("Title", text: $title)
///         Toggle("Enabled", isOn: $isEnabled)
///     }
/// }
/// ```
public struct SxnnyForm<Content: View>: View {
    /// The content to display within the form.
    private let content: () -> Content

    /// Creates a form styled with SxnnyUI’s base settings.
    ///
    /// - Parameter content: A view builder providing the content of the form.
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    /// The view’s body, rendering a standard form with SxnnyUI-specific styles.
    public var body: some View {
        Form {
            content()
        }
        .accentColor(SxnnyTheme.accentColor) // Applies the framework's accent color.
        .environment(\.defaultMinListRowHeight, 44) // Sets a standard minimum row height.
        .padding(SxnnyTheme.defaultPadding)
    }
}
