import Foundation

extension String {
    func appending(_ value: String, if condition: Bool) -> String {
        if condition {
            return appending(value)
        } else {
            return self
        }
    }

    func appending<T>(_ optional: T?, formatter: (T) -> String) -> String {
        if let value = optional {
            return appending(formatter(value))
        } else {
            return self
        }
    }

    func appending<T>(_ collection: T, formatter: (T) -> String) -> String where T: Collection {
        if collection.isEmpty {
            return self
        } else {
            return appending(formatter(collection))
        }
    }
}
