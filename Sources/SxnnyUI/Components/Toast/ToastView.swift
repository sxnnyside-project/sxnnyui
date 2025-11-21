//
//  ToastView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 16/04/25.
//  Credits to Ondrej Kvasnovsky


import SwiftUI

/// A view that represents a toast message.
///
/// The `ToastView` displays a message with a specific style and optional width.
/// It also supports an optional action for dismissing the toast.
public struct ToastView: View {
  /// The style of the toast, defining its appearance.
  var style: ToastStyle

  /// The message displayed in the toast.
  var message: String

  /// The width of the toast. Defaults to `.infinity`.
  var width: Double = .infinity

  /// An optional action to be executed when the toast is dismissed.
  var onDismiss: (() -> Void)?

  public var body: some View {
    HStack {
      Image(systemName: style.iconFileName)
        .foregroundColor(.white)
        .padding(.leading, 8)

      Text(message)
        .foregroundColor(.white)
        .font(.body)
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 8)

      Spacer()

      if let onDismiss = onDismiss {
        Button(action: onDismiss) {
          Image(systemName: "xmark")
            .foregroundColor(.white)
            .padding(.trailing, 8)
        }
      }
    }
    .frame(maxWidth: width)
    .padding()
    .background(style.themeColor)
    .cornerRadius(8)
    .shadow(radius: 4)
  }
}
