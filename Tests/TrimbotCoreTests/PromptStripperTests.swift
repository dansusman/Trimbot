import Testing
@testable import TrimbotCore

@Suite("PromptStripper")
struct PromptStripperTests {
    @Test func stripsDollar() {
        #expect(PromptStripper.strip("$ ls -la") == "ls -la")
    }

    @Test func stripsHashWhenCommandLike() {
        #expect(PromptStripper.strip("# brew install foo") == "brew install foo")
    }

    @Test func leavesMarkdownHeading() {
        #expect(PromptStripper.strip("# Release Notes") == "# Release Notes")
        #expect(PromptStripper.strip("## Heading Two") == "## Heading Two")
    }

    @Test func stripsPercent() {
        #expect(PromptStripper.strip("% pwd") == "pwd")
    }

    @Test func leavesAngleForBlockquote() {
        #expect(PromptStripper.strip("> quoted text") == "> quoted text")
    }

    @Test func handlesMultipleLines() {
        #expect(PromptStripper.strip("$ cd foo\n$ ls") == "cd foo\nls")
    }

    @Test func leavesIndentedAlone() {
        #expect(PromptStripper.strip("  not a prompt") == "  not a prompt")
    }

    @Test func leavesEmptyLines() {
        #expect(PromptStripper.strip("$ a\n\n$ b") == "a\n\nb")
    }
}
