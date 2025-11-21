//
//  ToastStyle.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 16/04/25.
//  Credits to Ondrej Kvasnovsky

import SwiftUI

/// An enumeration representing the style of a toast message.
///
/// The `ToastStyle` enum defines various styles for toast messages, each with a specific theme color and icon.
public enum ToastStyle {
  /// Represents an error toast style.
  case error

  /// Represents a warning toast style.
  case warning

  /// Represents a success toast style.
  case success

  /// Represents an informational toast style.
  case info
}

extension ToastStyle {
  /// The theme color associated with the toast style.
  ///
  /// - Returns: A `Color` representing the theme color of the style.
  public var themeColor: Color {
    switch self {
    case .error: return Color.red
    case .warning: return Color.orange
    case .info: return Color.blue
    case .success: return Color.green
    }
  }

  /// The system icon file name associated with the toast style.
  ///
  /// - Returns: A `String` representing the name of the system icon.
  public var iconFileName: String {
    switch self {
    case .info: return "info.circle.fill"
    case .warning: return "exclamationmark.triangle.fill"
    case .success: return "checkmark.circle.fill"
    case .error: return "xmark.circle.fill"
    }
  }
}
