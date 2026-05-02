import Testing
@testable import TrimbotCore

@Suite("Markdown preservation")
struct MarkdownPreservationTests {
    @Test func preservesBoldAndItalics() {
        let input = "This is **bold** and *italic* and ***both*** and _under_."
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesInlineCode() {
        let input = "Run `ls -la` then `pbpaste | trimbot`."
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesNestedUnorderedList() {
        let input = """
        - top one
          - nested under one
            - deeper still
          - back to nested
        - top two
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesOrderedList() {
        let input = """
        1. first
        2. second
        3. third
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesNestedOrderedList() {
        let input = """
        1. one
           1. one-a
           2. one-b
        2. two
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesMixedOrderedAndUnordered() {
        let input = """
        1. first
           - sub bullet
           - another sub
        2. second
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesTaskListCheckboxes() {
        let input = """
        - [ ] todo
        - [x] done
          - [ ] nested todo
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesBlockquote() {
        let input = "> This is a quoted line.\n> Another quoted line."
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesHeadings() {
        let input = """
        # Title
        ## Subtitle
        ### Section
        #### Detail
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesFencedCodeBlock() {
        let input = """
        ```swift
        let x = 1
            let y = 2
        ```
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesLinkSyntax() {
        let input = "See [Trimbot](https://example.com/trimbot) for details."
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesHorizontalRule() {
        let input = "above\n\n---\n\nbelow"
        #expect(Cleaner.clean(input) == input)
    }

    @Test func preservesTable() {
        let input = """
        | col a | col b |
        | ----- | ----- |
        | one   | two   |
        """
        #expect(Cleaner.clean(input) == input)
    }

    @Test func deeplyNestedListWithMixedMarkers() {
        let input = """
        - a
          * b
            + c
              1. d
                 - e
        """
        #expect(Cleaner.clean(input) == input)
    }
}
