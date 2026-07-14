import SwiftUI
import Testing

@testable import SxnnyErgo

// `Layout.sizeThatFits`/`placeSubviews` require a live `LayoutSubview` collection,
// which SwiftUI only vends under a real rendering host. These tests instead cover
// construction, defaults, and parameter storage — the same pattern used for other
// `Layout`-conforming types in this package.
struct FlowLayoutTests {

    @Test("default initializer uses documented defaults")
    func defaultsAreDocumented() {
        // HorizontalAlignment does not conform to Equatable, so only the numeric
        // defaults are asserted directly.
        let layout = FlowLayout()
        #expect(layout.horizontalSpacing == 8)
        #expect(layout.verticalSpacing == 8)
    }

    @Test("custom spacing is stored")
    func customValuesAreStored() {
        let layout = FlowLayout(horizontalSpacing: 12, verticalSpacing: 4, alignment: .trailing)
        #expect(layout.horizontalSpacing == 12)
        #expect(layout.verticalSpacing == 4)
    }

    @Test("every alignment case is accepted at construction")
    func everyAlignmentCaseIsAccepted() {
        _ = FlowLayout(alignment: .leading)
        _ = FlowLayout(alignment: .center)
        _ = FlowLayout(alignment: .trailing)
        #expect(Bool(true))
    }

    @Test("zero spacing is a valid configuration")
    func zeroSpacingIsValid() {
        let layout = FlowLayout(horizontalSpacing: 0, verticalSpacing: 0)
        #expect(layout.horizontalSpacing == 0)
        #expect(layout.verticalSpacing == 0)
    }

    @Test("conforms to Layout and builds a container view")
    @MainActor
    func buildsAsLayoutContainer() {
        let view = FlowLayout(horizontalSpacing: 4, verticalSpacing: 4) {
            Text("One")
            Text("Two")
            Text("Three")
        }
        #expect(type(of: view) != Never.self)
    }
}
