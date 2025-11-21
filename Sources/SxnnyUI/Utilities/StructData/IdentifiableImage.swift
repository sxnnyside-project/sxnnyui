//
//  IdentifiableImage.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 24/02/25.
//

import Foundation
import SwiftUI

// MARK: - UIKit-backed model (iOS, iPadOS, visionOS, tvOS where UIKit exists)
#if canImport(UIKit)
import UIKit

/// A data model that encapsulates a `UIImage` with a unique identifier.
///
/// `IdentifiableImage` conforms to `Identifiable`, making it suitable for SwiftUI collections
/// that require stable identity. You can optionally supply a stable `id`, otherwise a new UUID
/// is generated.
///
/// Example:
/// ```swift
/// let img = UIImage(systemName: "star")!
/// let identifiable = IdentifiableImage(image: img)
/// print(identifiable.id) // Unique UUID
/// ```
@MainActor
public struct IdentifiableImage: Identifiable, Hashable, Sendable {
    /// A unique identifier for the image.
    public let id: UUID
    /// The image associated with this instance.
    public let image: UIImage

    /// Initializes a new instance of `IdentifiableImage`.
    /// - Parameters:
    ///   - id: Optional stable identifier. Defaults to a new `UUID()`.
    ///   - image: The `UIImage` to associate with this instance.
    public init(id: UUID = UUID(), image: UIImage) {
        self.id = id
        self.image = image
    }
}

#else

// MARK: - Non-UIKit platforms (e.g., macOS without UIKit, watchOS)
// Provide a stub so the package compiles cross‑platform. The type exists but cannot hold a UIImage.

/// A stub IdentifiableImage for platforms without UIKit. This type exists to keep cross‑platform builds working,
/// but it does not carry an image payload.
public struct IdentifiableImage: Identifiable, Hashable, Sendable {
    public let id: UUID

    public init(id: UUID = UUID()) {
        self.id = id
    }
}

#endif
