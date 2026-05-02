import Foundation

public enum PromptStripper {
    public static func strip(_ input: String) -> String {
        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)
        return lines.map(stripLine).joined(separator: "\n")
    }

    private static func stripLine(_ line: Substring) -> String {
        guard let first = line.first else { return String(line) }
        guard "$%#".contains(first) else { return String(line) }
        if first == "#", looksLikeMarkdownHeading(line) { return String(line) }
        let afterPrompt = line.dropFirst()
        guard afterPrompt.first == " " else { return String(line) }
        return String(afterPrompt.dropFirst())
    }

    private static func looksLikeMarkdownHeading(_ line: Substring) -> Bool {
        var i = line.startIndex
        while i < line.endIndex, line[i] == "#" {
            i = line.index(after: i)
        }
        guard i < line.endIndex, line[i] == " " else { return false }
        let rest = line[line.index(after: i)...]
        guard let firstWord = rest.first else { return false }
        return firstWord.isLetter && firstWord.isUppercase
    }
}
