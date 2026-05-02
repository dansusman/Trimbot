import Foundation

public struct CleanResult: Sendable, Equatable {
    public let original: String
    public let cleaned: String
    public var changed: Bool { original != cleaned }
}

public enum Cleaner {
    public static func clean(_ input: String) -> String {
        process(input).cleaned
    }

    public static func process(_ input: String) -> CleanResult {
        var s = input
        s = AnsiStripper.strip(s)
        s = InvisibleStripper.strip(s)
        s = SidebarStripper.strip(s)
        s = BoxDrawingStripper.strip(s)
        s = PromptStripper.strip(s)
        s = UrlRewrapper.rewrap(s)
        s = IndentNormalizer.normalize(s)
        s = TrailingTrimmer.trim(s)
        return CleanResult(original: input, cleaned: s)
    }
}
