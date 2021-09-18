import SwiftSyntax

public enum GenericRequirementNode: Equatable, Hashable, CustomStringConvertible {
    case conformance(ConformanceRequirementNode)
    case sameType(SameTypeRequirementNode)

    public init?(syntax: GenericParameterSyntax) {
        if let node = ConformanceRequirementNode(syntax: syntax) {
            self = .conformance(node)
        } else {
            return nil
        }
    }

    public init(syntax: GenericRequirementSyntax) {
        if let syntax = syntax.body.as(ConformanceRequirementSyntax.self) {
            self = .conformance(.init(syntax: syntax))
        } else if let syntax = syntax.body.as(SameTypeRequirementSyntax.self) {
            self = .sameType(.init(syntax: syntax))
        } else {
            preconditionFailure("Unknown generic requirement syntax: \(syntax.syntaxNodeType)")
        }
    }

    public var description: String {
        switch self {
        case let .conformance(node):
            return node.description
        case let .sameType(node):
            return node.description
        }
    }

    private static func parseList(_ syntax: GenericParameterClauseSyntax?) -> Set<GenericRequirementNode> {
        return Set(syntax?.genericParameterList.compactMap(Self.init) ?? [])
    }

    private static func parseList(_ syntax: GenericWhereClauseSyntax?) -> Set<GenericRequirementNode> {
        return Set(syntax?.requirementList.map(Self.init) ?? [])
    }

    public static func parseList(parameterList: GenericParameterClauseSyntax? = nil, whereClause: GenericWhereClauseSyntax? = nil) -> Set<GenericRequirementNode> {
        #warning("TODO: unify constraints when using composite types")

        return Set<GenericRequirementNode>()
            .union(parseList(parameterList))
            .union(parseList(whereClause))
    }
}

public struct ConformanceRequirementNode: Equatable, Hashable, CustomStringConvertible {
    public var left: TypeNode
    public var right: TypeNode

    public init(syntax: ConformanceRequirementSyntax) {
        self.left = TypeNode(syntax: syntax.leftTypeIdentifier)
        self.right = TypeNode(syntax: syntax.rightTypeIdentifier)
    }

    public init?(syntax: GenericParameterSyntax) {
        if let inheritedType = syntax.inheritedType {
            self.left = .simple(SimpleTypeIdentifierNode(name: syntax.name.text, genericArguments: []))
            self.right = TypeNode(syntax: inheritedType)
        } else {
            return nil
        }
    }

    public var description: String {
        return "\(left): \(right)"
    }
}

public struct SameTypeRequirementNode: Equatable, Hashable, CustomStringConvertible {
    public var left: TypeNode
    public var right: TypeNode

    public init(syntax: SameTypeRequirementSyntax) {
        self.left = TypeNode(syntax: syntax.leftTypeIdentifier)
        self.right = TypeNode(syntax: syntax.rightTypeIdentifier)
    }

    public var description: String {
        return "\(left) == \(right)"
    }
}
