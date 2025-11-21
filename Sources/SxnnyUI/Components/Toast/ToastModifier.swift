//
//  ToastModifier.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 16/04/25.
//  Credits to Ondrej Kvasnovsky

import SwiftUI

/// A view modifier that displays a toast message over the current view.
///
/// The `ToastModifier` is responsible for managing the presentation and dismissal of a toast message.
/// It uses a `Binding<Toast?>` to dynamically show or hide the toast.
public struct ToastModifier: ViewModifier {
  
  /// A binding to an optional `Toast` object that represents the content and state of the toast.
  @Binding var toast: Toast?
  
  /// A work item used to schedule the dismissal of the toast after a specified duration.
  @State private var workItem: DispatchWorkItem?
  
  /// Applies the modifier to the content view.
  ///
  /// - Parameter content: The content view to which the toast will be added.
  /// - Returns: A view with the toast overlay applied.
  public func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          mainToastView()
            .offset(y: 32)
        }.animation(.spring(), value: toast)
      )
      .onChange(of: toast) { value in
        showToast()
      }
  }
  
  /// Creates the main toast view.
  ///
  /// This view is displayed as an overlay when the `toast` binding is not `nil`.
  @ViewBuilder func mainToastView() -> some View {
    if let toast = toast {
      VStack {
        ToastView(
          style: toast.style,
          message: toast.message,
          width: toast.width
        ) {
          dismissToast()
        }
        Spacer()
      }
    }
  }
  
  /// Displays the toast and schedules its dismissal if a duration is specified.
  private func showToast() {
    guard let toast = toast else { return }
    
    // Trigger haptic feedback when the toast appears.
    UIImpactFeedbackGenerator(style: .light)
      .impactOccurred()
    
    if toast.duration > 0 {
      workItem?.cancel()
      
      let task = DispatchWorkItem {
        dismissToast()
      }
      
      workItem = task
      DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
  }
  
  /// Dismisses the toast and cancels any scheduled dismissal tasks.
  private func dismissToast() {
    withAnimation {
      toast = nil
    }
    
    workItem?.cancel()
    workItem = nil
  }
}
