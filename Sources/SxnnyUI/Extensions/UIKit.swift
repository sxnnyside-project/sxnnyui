//
//  UIKit.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

// MARK: - UIKit Utilities (iOS, iPadOS, visionOS, tvOS where UIKit exists)

#if canImport(UIKit)
import UIKit

public extension UIApplication {
    /// Dismisses the keyboard by asking the current first responder to resign.
    ///
    /// This sends the `resignFirstResponder` action up the responder chain.
    /// Safe to call from anywhere on UIKit platforms.
    @inlinable
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension UIDevice {
    /// A readable device model identifier (for example, "iPhone15,3").
    ///
    /// This value is derived from `uname` and reflects the hardware identifier.
    /// It is not localized and may not correspond to a marketing name.
    @inlinable
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        // Extract the C char array into a Swift String.
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce(into: "") { result, element in
            guard let value = element.value as? Int8, value != 0 else { return }
            result.append(String(UnicodeScalar(UInt8(value))))
        }
    }
}

#else

// MARK: - Non-UIKit platforms
// UIKit is not available on this platform. These utilities are intentionally omitted to keep the package compiling cross‑platform.

#endif
