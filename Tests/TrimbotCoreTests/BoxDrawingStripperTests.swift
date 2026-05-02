import Testing
@testable import TrimbotCore

@Suite("BoxDrawingStripper")
struct BoxDrawingStripperTests {
    @Test func stripsAllBoxBorders() {
        let input = "┌─────────┐\n│ content │\n└─────────┘"
        #expect(BoxDrawingStripper.strip(input) == "\n content \n")
    }

    @Test func stripsHeavyAndDouble() {
        #expect(BoxDrawingStripper.strip("┃a┃ ║b║") == "a b")
    }

    @Test func stripsTeesAndCrosses() {
        #expect(BoxDrawingStripper.strip("├┤┬┴┼") == "")
    }

    @Test func leavesNonBoxAlone() {
        #expect(BoxDrawingStripper.strip("hello | world") == "hello | world")
    }

    @Test func collapsesTrailingWhitespaceFromBorderRow() {
        let input = "─────"
        #expect(BoxDrawingStripper.strip(input) == "")
    }
}
