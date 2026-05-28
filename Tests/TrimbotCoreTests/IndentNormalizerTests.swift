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

    @Test func stripsWrapContinuationUnderDashBullet() {
        let input = "- foo bar baz\n  qux quux\n- next item"
        #expect(IndentNormalizer.normalize(input) == "- foo bar baz\nqux quux\n- next item")
    }

    @Test func stripsWrapContinuationUnderNumberedItem() {
        let input = "1. first line wraps\n   continuation here\n2. second"
        #expect(IndentNormalizer.normalize(input) == "1. first line wraps\ncontinuation here\n2. second")
    }

    @Test func stripsBulletIndentWhenHeadingIsUnindented() {
        let input = "⏺ heading\n\n    - one\n    - two"
        #expect(IndentNormalizer.normalize(input) == "⏺ heading\n\n- one\n- two")
    }

    @Test func stripsBulletIndentPreservingNesting() {
        let input = "⏺ heading\n\n    - top\n      - nested\n    - second"
        #expect(IndentNormalizer.normalize(input) == "⏺ heading\n\n- top\n  - nested\n- second")
    }

    @Test func stripsBulletIndentAndWrapContinuation() {
        let input = "⏺ heading\n\n    - foo bar baz\n      qux quux\n    - next"
        #expect(IndentNormalizer.normalize(input) == "⏺ heading\n\n- foo bar baz\nqux quux\n- next")
    }

    @Test func stripsWrapContinuationButKeepsRealNesting() {
        let input = "- top\n  continuation\n  - nested\n- second"
        #expect(IndentNormalizer.normalize(input) == "- top\ncontinuation\n  - nested\n- second")
    }

    @Test func preservesSwiftSnippet() {
        let input = "func add(_ a: Int, _ b: Int) -> Int {\n    return a + b\n}"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesSwiftSnippetWithCommentary() {
        let input = "Here's a Swift function:\n\nfunc add(_ a: Int, _ b: Int) -> Int {\n    return a + b\n}\n\nHope this helps!"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesNestedSwiftSnippet() {
        let input = "struct Foo {\n    func bar() {\n        if x {\n            doThing()\n        }\n    }\n}"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesGoSnippet() {
        let input = "package main\n\nimport \"fmt\"\n\nfunc main() {\n    fmt.Println(\"hi\")\n}"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesGoSnippetWithCommentary() {
        let input = "Try this:\n\npackage main\n\nfunc main() {\n    for i := 0; i < 3; i++ {\n        fmt.Println(i)\n    }\n}\n\nThat should work."
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesPythonSnippet() {
        let input = "def add(a, b):\n    return a + b"
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesPythonSnippetWithCommentary() {
        let input = "Here you go:\n\ndef add(a, b):\n    if a > 0:\n        return a + b\n    return b\n\nLet me know."
        #expect(IndentNormalizer.normalize(input) == input)
    }

    @Test func preservesPythonClassWithMethods() {
        let input = "class Foo:\n    def bar(self):\n        for x in range(3):\n            print(x)"
        #expect(IndentNormalizer.normalize(input) == input)
    }
}
