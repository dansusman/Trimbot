import Testing
@testable import TrimbotCore

@Suite("SidebarStripper")
struct SidebarStripperTests {
    @Test func stripsClaudeCodeGutter() {
        let input = "▎ hello world\n▎ second line"
        #expect(SidebarStripper.strip(input) == "hello world\nsecond line")
    }

    @Test func stripsBoxDrawingVerticals() {
        let input = "│ first\n┃ second"
        #expect(SidebarStripper.strip(input) == "first\nsecond")
    }

    @Test func stripsLeadingWhitespaceBeforeMarker() {
        let input = "   ▎ indented"
        #expect(SidebarStripper.strip(input) == "indented")
    }

    @Test func stripsRepeatedMarkers() {
        let input = "▎▎ deep\n│ │ also"
        #expect(SidebarStripper.strip(input) == "deep\nalso")
    }

    @Test func preservesParagraphBreaks() {
        let input = "▎ para one\n▎\n▎ para two"
        #expect(SidebarStripper.strip(input) == "para one\n\npara two")
    }

    @Test func leavesPlainLinesAlone() {
        #expect(SidebarStripper.strip("normal line") == "normal line")
    }
}
