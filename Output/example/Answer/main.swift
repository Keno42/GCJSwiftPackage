// Define how to read input files here

// Write your algorithm here

import Swift

var arguments = CommandLine.arguments
arguments.removeFirst()

let fileContents = arguments.joined(separator: " ")
print("My String: \(fileContents)")
