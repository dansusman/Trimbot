import Foundation
import TrimbotCore

let data = FileHandle.standardInput.readDataToEndOfFile()
let input = String(data: data, encoding: .utf8) ?? ""
let output = Cleaner.clean(input)
FileHandle.standardOutput.write(Data(output.utf8))
