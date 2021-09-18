import SwiftSyntax

public struct ExprNode: Equatable, Hashable, CustomStringConvertible {
    #warning("TODO: not implemented")

    public let text: String

    public init(syntax: ExprSyntax) {
        self.text = syntax.withoutTrivia().description
    }

    public var description: String {
        return text
    }
}
