//
//  Optional.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

// MARK: - Optional Utilities

public extension Optional {

    /// Returns the wrapped value if it exists; otherwise, returns the provided default value.
    ///
    /// This is a convenience wrapper around the nil-coalescing operator (`??`) that can improve
    /// readability at call sites by making the intent explicit.
    ///
    /// Example:
    /// ```swift
    /// let name: String? = nil
    /// let display = name.or("Unknown") // "Unknown"
    /// ```
    ///
    /// - Parameter defaultValue: The value to return when `self` is `nil`.
    /// - Returns: The unwrapped value if present; otherwise `defaultValue`.
    @inlinable
    func or(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }
}
