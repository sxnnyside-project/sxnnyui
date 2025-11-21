//
//  ChartData.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import Foundation

/// A data model representing a single data point in a chart.
///
/// The `ChartData` struct encapsulates the essential components of a chart entry:
/// - `label`: a human‑readable descriptor
/// - `value`: the numeric magnitude
/// - `id`: a stable identity for use in identifiable collections (e.g., SwiftUI lists/charts)
///
/// Typical use cases include presenting chart information in user interfaces,
/// analytics dashboards, or any context where labeled numerical data is visualized.
public struct ChartData: Identifiable, Hashable, Codable, Sendable {
    /// A unique identifier for the chart data.
    public let id: UUID
    /// The label associated with the data point.
    public let label: String
    /// The value of the data point.
    public let value: Int

    /// Initializes a new instance of `ChartData`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the data point. Defaults to a new `UUID()`.
    ///   - label: The label associated with the data point.
    ///   - value: The value of the data point.
    public init(id: UUID = UUID(), label: String, value: Int) {
        self.id = id
        self.label = label
        self.value = value
    }
}

// MARK: - Internal helpers

extension ChartData {
    /// Creates a small set of sample data for previews/tests.
    /// Not public to avoid polluting the library API surface.
    static func sampleData() -> [ChartData] {
        [
            ChartData(label: "A", value: 10),
            ChartData(label: "B", value: 20),
            ChartData(label: "C", value: 15)
        ]
    }
}
