import Foundation

private let decoder = Util.decoder

func readInput() -> Int {
    return decoder.getRow()
}

func readInput() -> [Int] {
    return decoder.getRow()
}

func readInput() -> (Int, Int) {
    return decoder.getRow()
}

func readInput() -> String {
    return decoder.getRow()
}

private class Util {
    
    static let baseURL: URL = {
        var fileURL = URL(fileURLWithPath: #file)
        fileURL.deleteLastPathComponent()
        fileURL.deleteLastPathComponent()
        return fileURL
    }()
    
    static var decoder: InputFileDecoder {
        var arguments = CommandLine.arguments
        arguments.removeFirst()
        let file = arguments.joined(separator: " ")
        let input = Util.baseURL.appendingPathComponent(file)
        let data = try! String(contentsOf: input).components(separatedBy: "\n")
        return InputFileDecoder(input: data)
    }
}

private class InputFileDecoder {
    let input: [String]
    var index: Int
    
    init(input: [String]) {
        self.input = input
        index = self.input.startIndex
    }
    
    func getRow() -> String {
        let value = input[index]
        index += 1
        return value
    }
    
    func getRow() -> Int {
        return Int(getRow() as String)!
    }
    
    func getRow() -> [Int] {
        let row: String = getRow()
        let ary = row.components(separatedBy: " ")
        return ary.flatMap {
            return Int($0)
        }
    }
    
    func getRow()-> (Int, Int) {
        let row: [Int] = getRow()
        return (row[0], row[1])
    }
    
}
