import SwiftSyntax

extension SyntaxProtocol {
    func findAll<T>(of type: T.Type) -> [T] where T: SyntaxProtocol {
        var result: [T] = []
        Syntax(self).collectAll(of: type, into: &result)
        return result
    }
}

extension Syntax {
    fileprivate func collectAll<T>(of type: T.Type, into array: inout [T]) where T: SyntaxProtocol {
        if let output = self.as(T.self) {
            array.append(output)
        }

        for child in children {
            child.collectAll(of: type, into: &array)
        }
    }
}
