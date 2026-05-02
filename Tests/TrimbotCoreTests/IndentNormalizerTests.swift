import Testing
@testable import TrimbotCore

@Suite("IndentNormalizer")
struct IndentNormalizerTests {
    @Test func stripsCommonFourSpaceIndent() {
        let input = "    line one\n    line two\n    line three"
        #expect(IndentNormalizer.normalize(input) == "line one\nline two\nline three")
    }

    @Test func preservesRelativeIndent() {
        let input = "    outer\n      inner\n    outer again"
        #expect(IndentNormalizer.normalize(input) == "outer\n  inner\nouter again")
    }

    @Test func ignoresBlankLinesWhenComputingPrefix() {
        let input = "    a\n\n    b"
        #expect(IndentNormalizer.normalize(input) == "a\n\nb")
    }

    @Test func leavesUnindentedAlone() {
        #expect(IndentNormalizer.normalize("a\nb") == "a\nb")
    }

    @Test func handlesTabsConsistently() {
        let input = "\t\tone\n\t\ttwo"
        #expect(IndentNormalizer.normalize(input) == "one\ntwo")
    }

    @Test func mixedPrefixUsesShortest() {
        let input = "  two\n    four"
        #expect(IndentNormalizer.normalize(input) == "two\n  four")
    }

    @Test func flattensPerLineWhenNoSharedPrefix() {
        let input = "no indent\n    indented"
        #expect(IndentNormalizer.normalize(input) == "no indent\nindented")
    }

    @Test func handlesAgentBulletWithWrappedContinuations() {
        let input = "⏺ headline\n\n  wrapped one\n\n  wrapped two"
        #expect(IndentNormalizer.normalize(input) == "⏺ headline\n\nwrapped one\n\nwrapped two")
    }

    @Test func preservesMarkdownDashBulletNesting() {
        let input = "- top\n  - nested\n    - deeper\n- second top"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesMarkdownStarBulletNesting() {
        let input = "* one\n  * two\n* three"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesNumberedListNesting() {
        let input = "1. first\n   1. nested\n2. second"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func stripsCommonPrefixEvenWhenMarkdownPresent() {
        let input = "    - one\n      - nested\n    - two"
        #expect(IndentNormalizer.normalize(input) == "- one\n  - nested\n- two")
    }

    @Test func emptyInputUnchanged() {
        #expect(IndentNormalizer.normalize("") == "")
    }
}
