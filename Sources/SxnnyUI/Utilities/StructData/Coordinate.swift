//
//  Coordinate.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// A data model representing a geographical coordinate with latitude and longitude.
///
/// `Coordinate` is a generic struct that can store coordinates using any numeric type that conforms to
/// `Numeric`, `Comparable`, and `Hashable`. This allows for flexibility in precision and range (e.g., `Double`,
/// `Float`, `Int`). It is useful for representing points on the Earth's surface or in any 2D planar system.
///
/// - Parameters:
///   - T: The numeric type used for latitude and longitude (e.g., `Double`, `Float`, `Int`).
///
/// Usage example:
/// ```swift
/// let cityCoordinate = Coordinate<Double>(latitude: 37.7749, longitude: -122.4194)
/// ```
public struct Coordinate<T: Numeric & Comparable & Hashable>: Equatable, Hashable {
    /// The latitude of the coordinate.
    public let latitude: T
    /// The longitude of the coordinate.
    public let longitude: T

    /// Initializes a new instance of `Coordinate`.
    /// - Parameters:
    ///   - latitude: The latitude of the coordinate.
    ///   - longitude: The longitude of the coordinate.
    public init(latitude: T, longitude: T) {
        self.latitude = latitude
        self.longitude = longitude
    }

    /// Conforms to the `Hashable` protocol by combining the latitude and longitude values.
    /// - Parameter hasher: The hasher to use when combining the components of this instance
    ///   into a single hash value.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

// MARK: - Conditional conformances

extension Coordinate: Sendable where T: Sendable {}

extension Coordinate: Codable where T: Codable {}
