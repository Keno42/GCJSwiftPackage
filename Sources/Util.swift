import Foundation

enum GCJReadInputError: Error {
    case invalidType
}

protocol GCJInputComvertible {
    static func convert(decoder: GCJInputDecoder) throws -> Self
}

func readInputNumber() throws -> Int {
    return try Util().readInputCount()
}

func readInput<Input: GCJInputComvertible>() throws -> [Input] {
    return try Util().readInput()
}

class Util {
    
    static let baseURL: URL = {
        var fileURL = URL(fileURLWithPath: #file)
        fileURL.deleteLastPathComponent()
        return fileURL
    }()
    
    let data: [String]
    init(data: String) {
        self.data = data.components(separatedBy: "\n")
    }
    
    convenience init() throws {
        var arguments = CommandLine.arguments
        arguments.removeFirst()
        let file = arguments.joined(separator: " ")
        let input = Util.baseURL.appendingPathComponent(file)
        self.init(data: try String(contentsOf: input))
    }
    
    func readInput<Input: GCJInputComvertible>() throws -> [Input] {
        let inputCount: Int = try readInputCount()
        let input: [String] = try readInputData()
        
        let decoder = GCJInputDecoder(input: input)
        
        var result: [Input] = []
        for _ in 0..<inputCount {
            let value = try Input.convert(decoder: decoder)
            result.append(value)
        }
        
        if result.count < inputCount {
            throw GCJReadInputError.invalidType
        }

        return result
    }
    
    func readInputCount() throws -> Int {
        if let firstLine = data.first,
            let value = Int(firstLine) {
            return value
        }
        throw GCJReadInputError.invalidType
    }
    
    func readInputData() throws -> [String] {
        var data = self.data
        data.removeFirst()
        return data
    }
}

class GCJInputDecoder {
    let input: [String]
    var index: Int
    
    init(input: [String]) {
        self.input = input
        index = self.input.startIndex
    }
    
    func getRow() throws -> String {
        guard index < input.endIndex else {
            throw GCJReadInputError.invalidType
        }
        let value = input[index]
        index += 1
        return value
    }
    
    func getRow() throws -> Int {
        guard let value = Int(try getRow() as String) else {
            throw GCJReadInputError.invalidType
        }
        return value
    }
    
    func getRow() throws -> [Int] {
        let row: String = try getRow()
        let ary = row.components(separatedBy: " ")
        return try ary.flatMap {
            if let v = Int($0) {
                return v
            }
            throw GCJReadInputError.invalidType
        }
    }
    
    func getRow() throws -> (Int, Int) {
        let row: [Int] = try getRow()
        return (row[0], row[1])
    }
    
    func getLines(lines count: Int) throws -> [String] {
        var lines: [String] = []
        for _ in 0..<count {
            lines.append(try getRow())
        }
        return lines
    }
    
}

extension String: GCJInputComvertible {
    
    static func convert(decoder: GCJInputDecoder) throws -> String {
        return try decoder.getRow()
    }

}
