//
//  Toast.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 16/04/25.
//  Credits to Ondrej Kvasnovsky

/// A structure representing a toast message.
///
/// The `Toast` struct is used to define the content and behavior of a toast message.
/// It includes properties for the style, message, duration, and width of the toast.
public struct Toast: Equatable {
    /// The style of the toast, defining its appearance.
    var style: ToastStyle
    
    /// The message displayed in the toast.
    var message: String
    
    /// The duration for which the toast is displayed, in seconds.
    var duration: Double = 3
    
    /// The width of the toast. Defaults to `.infinity`.
    var width: Double = .infinity
    
    /// Initializes a new `Toast` with the specified style, message, duration, and width.
    ///
    /// - Parameters:
    ///   - style: The style of the toast.
    ///   - message: The message displayed in the toast.
    ///   - duration: The duration for which the toast is displayed, in seconds.
    ///   - width: The width of the toast.
    public init(style: ToastStyle, message: String, duration: Double, width: Double) {
        self.style = style
        self.message = message
        self.duration = duration
        self.width = width
    }
    
    /// Initializes a new `Toast` with the specified style and message.
    ///
    /// - Parameters:
    ///   - style: The style of the toast.
    ///   - message: The message displayed in the toast.
    public init(style: ToastStyle, message: String) {
        self.style = style
        self.message = message
    }
}
