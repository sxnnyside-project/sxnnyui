//
//  BindingToast.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 16/04/25.
//


import SwiftUI

extension View {
  /// Adds a toast view to the current view.
  ///
  /// This modifier allows you to display a toast message over the current view. The toast is bound to a `Binding<Toast?>`,
  /// which means it can be dynamically updated or dismissed by setting the binding to `nil`.
  ///
  /// - Parameter toast: A binding to an optional `Toast` object that represents the content and state of the toast.
  /// - Returns: A view with the toast overlay applied.
  public func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
