import SwiftUI
import Testing

@testable import SxnnyErgo

// As with `FlowLayoutTests`, `sizeThatFits`/`placeSubviews` require a live
// `LayoutSubview` collection only available under a real rendering host, so these
// tests cover construction, defaults, and parameter storage instead.
struct EqualSizeLayoutTests {

    @Test("default initializer matches horizontally")
    func defaultMatchesHorizontal() {
        let layout = EqualSizeLayout()
        #expect(layout.matching == .horizontal)
    }

    @Test("matching accepts vertical only")
    func matchingAcceptsVertical() {
        let layout = EqualSizeLayout(matching: .vertical)
        #expect(layout.matching == .vertical)
    }

    @Test("matching accepts both axes")
    func matchingAcceptsBothAxes() {
        let layout = EqualSizeLayout(matching: [.horizontal, .vertical])
        #expect(layout.matching.contains(.horizontal))
        #expect(layout.matching.contains(.vertical))
    }

    @Test("conforms to Layout and builds a container view")
    @MainActor
    func buildsAsLayoutContainer() {
        let view = EqualSizeLayout(matching: .horizontal) {
            Button("OK") {}
            Button("Cancel") {}
            Button("Learn More") {}
        }
        #expect(type(of: view) != Never.self)
    }
}
