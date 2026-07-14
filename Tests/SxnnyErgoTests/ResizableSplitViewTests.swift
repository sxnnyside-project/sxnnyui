//
//  ResizableSplitViewTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("ResizableSplitView construction and configuration")
struct ResizableSplitViewTests {

    @Test("builds with default parameters")
    func buildsWithDefaults() {
        _ = ResizableSplitView(
            first: { Text("First") },
            second: { Text("Second") }
        )
    }

    @Test("accepts SwiftUI.Axis directly, with no separate local Axis type")
    func usesSwiftUIAxis() {
        // Regression coverage: the former SxnnySplitView declared its own nested `Axis`
        // enum that shadowed `SwiftUI.Axis` (NAMING.md's canonical anti-pattern example).
        // Passing `SwiftUI.Axis.horizontal` / `.vertical` directly, with no qualification
        // needed beyond what any other SwiftUI API requires, proves no shadow type exists.
        let horizontal: Axis = .horizontal
        let vertical: Axis = .vertical
        _ = ResizableSplitView(axis: horizontal, first: { Text("A") }, second: { Text("B") })
        _ = ResizableSplitView(axis: vertical, first: { Text("A") }, second: { Text("B") })
    }

    @Test("builds with every parameter customized")
    func buildsWithCustomParameters() {
        _ = ResizableSplitView(
            axis: .vertical,
            initialSplit: 0.3,
            minSplit: 0.1,
            maxSplit: 0.9,
            dividerThickness: 4,
            dividerColor: .blue,
            first: { Text("Top") },
            second: { Text("Bottom") }
        )
    }

    @Test("an out-of-range initial split does not trap; construction always succeeds")
    func outOfRangeInitialSplitDoesNotTrap() {
        _ = ResizableSplitView(
            initialSplit: 5.0,
            minSplit: 0.2,
            maxSplit: 0.8,
            first: { Text("A") },
            second: { Text("B") }
        )
        _ = ResizableSplitView(
            initialSplit: -3.0,
            minSplit: 0.2,
            maxSplit: 0.8,
            first: { Text("A") },
            second: { Text("B") }
        )
    }
}
