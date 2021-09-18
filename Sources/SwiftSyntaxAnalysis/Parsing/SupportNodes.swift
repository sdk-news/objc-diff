import SwiftSyntax

extension String {
    public static func parseList(_ syntax: GenericParameterClauseSyntax?) -> [String] {
        return syntax?.genericParameterList.map(\.name.text) ?? []
    }
}

public struct OpaqueNode: Equatable, Hashable, CustomStringConvertible {
    public let text: String

    public init(syntax: Syntax) {
        self.text = syntax.withoutTrivia().description
    }

    public var description: String {
        return text
    }
}

public struct ArgumentNode: Equatable, Hashable, CustomStringConvertible {
    public var label: String?
    public var expression: ExprNode

    public init(syntax: TupleExprElementSyntax) {
        self.label = syntax.label?.text
        self.expression = ExprNode(syntax: syntax.expression)
    }

    public var description: String {
        return ""
            .appending(label) { "\($0): " }
            .appending("\(expression)")
    }

    public static func parseList(_ syntax: TupleExprElementListSyntax?) -> [ArgumentNode] {
        return syntax?.compactMap(Self.init) ?? []
    }
}

public enum TypeOrProtocolNode: Equatable, Hashable, CustomStringConvertible {
    case type
    case `protocol`

    public init(syntax: TokenSyntax) {
        switch syntax.tokenKind {
        case .identifier("Type"):
            self = .type
        case .identifier("Protocol"):
            self = .protocol
        case let tokenKind:
            preconditionFailure("Unexpected token for metatype: \(tokenKind)")
        }
    }

    public var description: String {
        switch self {
        case .type:
            return "Type"
        case .protocol:
            return "Protocol"
        }
    }
}

public struct SpecifierNode: Equatable, Hashable, CustomStringConvertible {
    public var name: String

    public init(syntax: TokenSyntax) {
        self.name = syntax.text
    }

    public var description: String {
        return name
    }
}

public struct ModifierNode: Equatable, Hashable, CustomStringConvertible {
    public var name: String
    public var detail: String?

    public init(name: String, detail: String? = nil) {
        self.name = name
        self.detail = detail
    }

    public init(syntax: DeclModifierSyntax) {
        self.name = syntax.name.text
        self.detail = syntax.detail?.text
    }

    public var description: String {
        return name.appending(detail) { "(\($0)" }
    }

    public static func parseList(_ syntax: ModifierListSyntax?) -> Set<ModifierNode> {
        return Set(syntax?.map(Self.init) ?? [])
    }

    public static let `class` = ModifierNode(name: "class")
    public static let `static` = ModifierNode(name: "static")

    public static let `open` = ModifierNode(name: "open")
    public static let `public` = ModifierNode(name: "public")
}

public struct AccessorKindNode: Equatable, Hashable, CustomStringConvertible {
    public var name: String

    public init(name: String) {
        self.name = name
    }

    public init(syntax: TokenSyntax) {
        self.name = syntax.text
    }

    public var description: String {
        return name
    }

    public static let get = AccessorKindNode(name: "get")
}

public enum AsyncOrReasyncNode: Equatable, Hashable, CustomStringConvertible {
    case `async`
    case `reasync`

    public init(syntax: TokenSyntax) {
        switch syntax.tokenKind {
        case .contextualKeyword("async"):
            self = .async
        case .contextualKeyword("reasync"):
            self = .reasync
        case let tokenKind:
            preconditionFailure("Unexpected token for async/reasync: \(tokenKind)")
        }
    }

    public var description: String {
        switch self {
        case .async:
            return "async"
        case .reasync:
            return "reasync"
        }
    }
}

public enum ThrowsOrRethrowsNode: Equatable, Hashable, CustomStringConvertible {
    case `throws`
    case `rethrows`

    public init(syntax: TokenSyntax) {
        switch syntax.tokenKind {
        case .throwsKeyword:
            self = .throws
        case .rethrowsKeyword:
            self = .rethrows
        case let tokenKind:
            preconditionFailure("Unexpected token for throws/rethrows: \(tokenKind)")
        }
    }

    public var description: String {
        switch self {
        case .throws:
            return "throws"
        case .rethrows:
            return "rethrows"
        }
    }
}

public enum LetOrVarNode: Equatable, Hashable, CustomStringConvertible {
    case `let`
    case `var`

    public init(syntax: TokenSyntax) {
        switch syntax.tokenKind {
        case .letKeyword:
            self = .let
        case .varKeyword:
            self = .var
        case let tokenKind:
            preconditionFailure("Unexpected token for let/var: \(tokenKind)")
        }
    }

    public var description: String {
        switch self {
        case .let:
            return "let"
        case .var:
            return "var"
        }
    }
}
