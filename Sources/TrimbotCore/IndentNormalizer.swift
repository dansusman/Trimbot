import Foundation

public enum IndentNormalizer {
    public static func normalize(_ input: String) -> String {
        guard !input.isEmpty else { return input }
        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)
        if let prefix = commonPrefix(lines) {
            let stripped = lines.map { line -> Substring in
                isBlank(line) ? line : line.dropFirst(prefix.count)
            }
            return stripped.joined(separator: "\n")
        }
        if hasMarkdownStructure(lines) {
            return stripWrapContinuations(lines).joined(separator: "\n")
        }
        if looksLikeCode(lines) {
            return input
        }
        let stripped = lines.map { line -> Substring in
            isBlank(line) ? line : line.drop { $0 == " " || $0 == "\t" }
        }
        return stripped.joined(separator: "\n")
    }

    private static let codeLinePrefixes: [String] = [
        "func ", "def ", "class ", "import ", "package ", "from ",
        "var ", "let ", "const ", "type ", "struct ", "enum ", "protocol ",
        "interface ", "public ", "private ", "internal ", "fileprivate ",
        "return ", "if ", "for ", "while ", "switch ", "case ", "guard ",
        "func(", "fn ", "fn(",
    ]

    private static func looksLikeCode(_ lines: [Substring]) -> Bool {
        var sawOpenBrace = false
        var sawCloseBrace = false
        for line in lines {
            let body = line.drop { $0 == " " || $0 == "\t" }
            if body.isEmpty { continue }
            for prefix in codeLinePrefixes where body.hasPrefix(prefix) {
                return true
            }
            if body == "return" { return true }
            if line.contains("{") { sawOpenBrace = true }
            if line.contains("}") { sawCloseBrace = true }
        }
        return sawOpenBrace && sawCloseBrace
    }

    private static func stripWrapContinuations(_ lines: [Substring]) -> [Substring] {
        let bulletPrefix = minListLineIndent(lines)
        var inFence = false
        return lines.map { line -> Substring in
            if isFencedCodeDelimiter(line) {
                inFence.toggle()
                return line
            }
            if inFence || isBlank(line) { return line }
            if isMarkdownListLine(line) || isBlockquoteLine(line) || isTableLine(line) {
                return dropLeading(line, count: bulletPrefix)
            }
            return line.drop { $0 == " " || $0 == "\t" }
        }
    }

    private static func minListLineIndent(_ lines: [Substring]) -> Int {
        var minimum: Int? = nil
        for line in lines where isMarkdownListLine(line) {
            let n = leadingWhitespace(line).count
            minimum = minimum.map { Swift.min($0, n) } ?? n
        }
        return minimum ?? 0
    }

    private static func dropLeading(_ line: Substring, count: Int) -> Substring {
        var i = line.startIndex
        var dropped = 0
        while i < line.endIndex, dropped < count, line[i] == " " || line[i] == "\t" {
            i = line.index(after: i)
            dropped += 1
        }
        return line[i...]
    }

    private static func hasMarkdownStructure(_ lines: [Substring]) -> Bool {
        lines.contains(where: isMarkdownListLine)
            || lines.contains(where: isFencedCodeDelimiter)
            || lines.contains(where: isBlockquoteLine)
            || lines.contains(where: isTableLine)
    }

    private static func isFencedCodeDelimiter(_ line: Substring) -> Bool {
        let body = line.drop { $0 == " " || $0 == "\t" }
        return body.hasPrefix("```") || body.hasPrefix("~~~")
    }

    private static func isBlockquoteLine(_ line: Substring) -> Bool {
        let body = line.drop { $0 == " " || $0 == "\t" }
        guard let first = body.first else { return false }
        if first != ">" { return false }
        let after = body.dropFirst()
        return after.first == " " || after.isEmpty
    }

    private static func isTableLine(_ line: Substring) -> Bool {
        let body = line.drop { $0 == " " || $0 == "\t" }
        return body.hasPrefix("|") && body.contains("|") && body.dropFirst().contains("|")
    }

    private static func isMarkdownListLine(_ line: Substring) -> Bool {
        let body = line.drop { $0 == " " || $0 == "\t" }
        guard let first = body.first else { return false }
        if first == "-" || first == "*" || first == "+" {
            let after = body.dropFirst()
            return after.first == " " || after.first == "\t"
        }
        if first.isNumber {
            var i = body.startIndex
            while i < body.endIndex, body[i].isNumber { i = body.index(after: i) }
            guard i < body.endIndex, body[i] == "." else { return false }
            let afterDot = body.index(after: i)
            guard afterDot < body.endIndex else { return false }
            return body[afterDot] == " " || body[afterDot] == "\t"
        }
        return false
    }

    private static func commonPrefix(_ lines: [Substring]) -> [Character]? {
        var prefix: [Character]? = nil
        for line in lines where !isBlank(line) {
            let leading = leadingWhitespace(line)
            guard !leading.isEmpty else { return nil }
            if let existing = prefix {
                let shared = zip(existing, leading).prefix { $0 == $1 }.map(\.0)
                if shared.isEmpty { return nil }
                prefix = Array(shared)
            } else {
                prefix = leading
            }
        }
        return prefix
    }

    private static func leadingWhitespace(_ line: Substring) -> [Character] {
        var result: [Character] = []
        for ch in line {
            if ch == " " || ch == "\t" { result.append(ch) } else { break }
        }
        return result
    }

    private static func isBlank(_ line: Substring) -> Bool {
        line.allSatisfy { $0 == " " || $0 == "\t" }
    }
}
