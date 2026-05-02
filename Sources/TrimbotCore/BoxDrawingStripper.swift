import Foundation

public enum BoxDrawingStripper {
    public static func strip(_ input: String) -> String {
        var scalars = String.UnicodeScalarView()
        scalars.reserveCapacity(input.unicodeScalars.count)
        for scalar in input.unicodeScalars {
            if isBoxDrawing(scalar) { continue }
            scalars.append(scalar)
        }
        return String(scalars)
    }

    private static func isBoxDrawing(_ scalar: Unicode.Scalar) -> Bool {
        (0x2500...0x257F).contains(scalar.value)
    }
}
