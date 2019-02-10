import Foundation

public enum QueryError: Error, CustomStringConvertible {
    case noSuchTable(name: String)
    case noSuchColumn(name: String, columns: [String])
    case ambiguousColumn(name: String, similar: [String])
    case unexpectedNullValue(name: String)

    public var description: String {
        switch self {
        case let .noSuchTable(name):
            return "No such table: \(name)"
        case let .noSuchColumn(name, columns):
            return "No such column `\(name)` in columns \(columns)"
        case let .ambiguousColumn(name, similar):
            return "Ambiguous column `\(name)` (please disambiguate: \(similar))"
        case let .unexpectedNullValue(name):
            return "Unexpected null value for column `\(name)`"
        }
    }
}
