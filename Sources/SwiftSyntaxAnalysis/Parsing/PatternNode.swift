import SwiftSyntax

public indirect enum PatternNode: Equatable, Hashable, CustomStringConvertible {
    case asType(AsTypePatternNode)
    case enumCase(EnumCasePatternNode)
    case expression(ExpressionPatternNode)
    case identifier(IdentifierPatternNode)
    case isType(IsTypePatternNode)
    case optional(OptionalPatternNode)
    case tuple(TuplePatternNode)
    case valueBinding(ValueBindingPatternNode)
    case wildcard(WildcardPatternNode)

    public init(syntax: PatternSyntax) {
        if let syntax = syntax.as(AsTypePatternSyntax.self) {
            self = .asType(.init(syntax: syntax))
        } else if let syntax = syntax.as(EnumCasePatternSyntax.self) {
            self = .enumCase(.init(syntax: syntax))
        } else if let syntax = syntax.as(ExpressionPatternSyntax.self) {
            self = .expression(.init(syntax: syntax))
        } else if let syntax = syntax.as(IdentifierPatternSyntax.self) {
            self = .identifier(.init(syntax: syntax))
        } else if let syntax = syntax.as(IsTypePatternSyntax.self) {
            self = .isType(.init(syntax: syntax))
        } else if let syntax = syntax.as(OptionalPatternSyntax.self) {
            self = .optional(.init(syntax: syntax))
        } else if let syntax = syntax.as(TuplePatternSyntax.self) {
            self = .tuple(.init(syntax: syntax))
        } else if let syntax = syntax.as(ValueBindingPatternSyntax.self) {
            self = .valueBinding(.init(syntax: syntax))
        } else if let syntax = syntax.as(WildcardPatternSyntax.self) {
            self = .wildcard(.init(syntax: syntax))
        } else if let syntax = syntax.as(UnknownPatternSyntax.self) {
            preconditionFailure("Unknown pattern syntax: \(syntax.syntaxNodeType)")
        } else {
            preconditionFailure("Unknown pattern syntax: \(syntax.syntaxNodeType)")
        }
    }

    public var description: String {
        switch self {
        case let .asType(node):
            return node.description
        case let .enumCase(node):
            return node.description
        case let .expression(node):
            return node.description
        case let .identifier(node):
            return node.description
        case let .isType(node):
            return node.description
        case let .optional(node):
            return node.description
        case let .tuple(node):
            return node.description
        case let .valueBinding(node):
            return node.description
        case let .wildcard(node):
            return node.description
        }
    }
}

public struct AsTypePatternNode: Equatable, Hashable, CustomStringConvertible {
    public var pattern: PatternNode
    public var type: TypeNode

    public init(syntax: AsTypePatternSyntax) {
        self.pattern = PatternNode(syntax: syntax.pattern)
        self.type = TypeNode(syntax: syntax.type)
    }

    public var description: String {
        return "\(pattern) as \(type)"
    }
}

public struct EnumCasePatternNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode?
    public var caseName: String
    public var associatedTuple: TuplePatternNode?

    public init(syntax: EnumCasePatternSyntax) {
        self.type = syntax.type.map(TypeNode.init)
        self.caseName = syntax.caseName.text
        self.associatedTuple = syntax.associatedTuple.map(TuplePatternNode.init)
    }

    public var description: String {
        return ""
            .appending(type) { $0.description }
            .appending(".\(caseName)")
            .appending(associatedTuple) { $0.description }
    }
}

public struct ExpressionPatternNode: Equatable, Hashable, CustomStringConvertible {
    public var expression: ExprNode

    public init(syntax: ExpressionPatternSyntax) {
        self.expression = ExprNode(syntax: syntax.expression)
    }

    public var description: String {
        return expression.description
    }
}

public struct IdentifierPatternNode: Equatable, Hashable, CustomStringConvertible {
    public var name: String

    public init(syntax: IdentifierPatternSyntax) {
        self.name = syntax.identifier.text
    }

    public var description: String {
        return name
    }
}

public struct IsTypePatternNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode

    public init(syntax: IsTypePatternSyntax) {
        self.type = TypeNode(syntax: syntax.type)
    }

    public var description: String {
        return "is \(type)"
    }
}

public struct OptionalPatternNode: Equatable, Hashable, CustomStringConvertible {
    public var pattern: PatternNode

    public init(syntax: OptionalPatternSyntax) {
        self.pattern = PatternNode(syntax: syntax.subPattern)
    }

    public var description: String {
        return "\(pattern)?"
    }
}

public struct TuplePatternNode: Equatable, Hashable, CustomStringConvertible {
    public var elements: [TuplePatternElementNode]

    public init(syntax: TuplePatternSyntax) {
        self.elements = TuplePatternElementNode.parseList(syntax.elements)
    }

    public var description: String {
        return "(\(elements.map(\.description).commaSeparated()))"
    }
}

public struct TuplePatternElementNode: Equatable, Hashable, CustomStringConvertible {
    public var label: String?
    public var pattern: PatternNode

    public init(syntax: TuplePatternElementSyntax) {
        self.label = syntax.labelName?.text
        self.pattern = PatternNode(syntax: syntax.pattern)
    }

    public var description: String {
        return ""
            .appending(label) { "\($0): " }
            .appending(pattern.description)
    }

    public static func parseList(_ syntax: TuplePatternElementListSyntax) -> [TuplePatternElementNode] {
        return syntax.map(Self.init)
    }
}

public struct ValueBindingPatternNode: Equatable, Hashable, CustomStringConvertible {
    public var letOrVar: LetOrVarNode
    public var pattern: PatternNode

    public init(syntax: ValueBindingPatternSyntax) {
        self.letOrVar = LetOrVarNode(syntax: syntax.letOrVarKeyword)
        self.pattern = PatternNode(syntax: syntax.valuePattern)
    }

    public var description: String {
        return "\(letOrVar) \(pattern)"
    }
}

public struct WildcardPatternNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode?

    public init(syntax: WildcardPatternSyntax) {
        self.type = (syntax.typeAnnotation?.type).map(TypeNode.init)
    }

    public var description: String {
        return "_".appending(type) { ": \($0)" }
    }
}
