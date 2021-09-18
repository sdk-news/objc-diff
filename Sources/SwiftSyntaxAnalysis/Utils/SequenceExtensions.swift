import Foundation

extension Sequence where Element == String {
    func commaSeparated() -> String {
        return joined(separator: ", ")
    }
}
