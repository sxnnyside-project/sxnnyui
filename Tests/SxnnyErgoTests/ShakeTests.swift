//
//  ShakeTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("View.shake(trigger:)")
struct ShakeTests {

    @Test("builds without trapping for various trigger types")
    func builds() {
        _ = Text("x").shake(trigger: 0)
        _ = Text("x").shake(trigger: "idle")
        _ = Text("x").shake(trigger: true)
    }

    @Test("ShakeGeometryEffect animatableData round-trips progress")
    func geometryEffectAnimatableDataRoundTrips() {
        var effect = ShakeGeometryEffect(progress: 0)
        effect.animatableData = 0.5
        #expect(effect.animatableData == 0.5)
    }

    @Test("ShakeGeometryEffect produces no horizontal offset at progress 0 and 1")
    func geometryEffectRestsAtBounds() {
        let start = ShakeGeometryEffect(progress: 0)
        let end = ShakeGeometryEffect(progress: 1)
        let startTransform = start.effectValue(size: CGSize(width: 100, height: 20))
        let endTransform = end.effectValue(size: CGSize(width: 100, height: 20))
        #expect(startTransform == ProjectionTransform(.identity))
        #expect(endTransform == ProjectionTransform(.identity))
    }
}
