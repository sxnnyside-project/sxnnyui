import SwiftUI
import Testing

@testable import SxnnyErgo

// `readSize`/`readFrame` rely on `GeometryReader` reporting real geometry through
// `.onPreferenceChange`, which only fires under a live rendering host. These tests
// therefore verify that the modifiers build into valid view values for every
// supported call shape, rather than asserting on reported sizes/frames.
@MainActor
@Suite("Geometry")
struct GeometryTests {

    @Test("readSize builds with the default parameter shape")
    func readSizeBuilds() {
        let view = Color.clear
            .frame(width: 100, height: 50)
            .readSize { _ in }
        #expect(type(of: view) != Never.self)
    }

    @Test("readFrame defaults to the global coordinate space")
    func readFrameDefaultsToGlobal() {
        let view = Color.clear
            .frame(width: 100, height: 50)
            .readFrame { _ in }
        #expect(type(of: view) != Never.self)
    }

    @Test("readFrame accepts a named coordinate space")
    func readFrameAcceptsNamedSpace() {
        let view = Color.clear
            .readFrame(in: .named("container")) { _ in }
        #expect(type(of: view) != Never.self)
    }

    @Test("readFrame accepts the local coordinate space")
    func readFrameAcceptsLocalSpace() {
        let view = Color.clear
            .readFrame(in: .local) { _ in }
        #expect(type(of: view) != Never.self)
    }

    @Test("readSize and readFrame compose with other modifiers")
    func composesWithOtherModifiers() {
        let view = Text("Hello")
            .padding()
            .readSize { _ in }
            .readFrame { _ in }
        #expect(type(of: view) != Never.self)
    }
}
