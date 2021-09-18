import SwiftSyntax

public indirect enum TypeNode: Equatable, Hashable, CustomStringConvertible {
    case simple(SimpleTypeIdentifierNode)
    case optional(OptionalTypeNode)
    case member(MemberTypeIdentifierNode)
    case tuple(TupleTypeNode)
    case function(FunctionTypeNode)
    case array(ArrayTypeNode)
    case dictionary(DictionaryTypeNode)
    case some(SomeTypeNode)
    case implicitlyUnwrappedOptional(ImplicitlyUnwrappedOptionalTypeNode)
    case composition(CompositionTypeNode)
    case attributed(AttributedTypeNode)
    case metatype(MetatypeTypeNode)
    case unknown

    public init(syntax: TypeSyntax) {
        if let syntax = syntax.as(SimpleTypeIdentifierSyntax.self) {
            self = .simple(.init(syntax: syntax))
        } else if let syntax = syntax.as(OptionalTypeSyntax.self) {
            self = .optional(.init(syntax: syntax))
        } else if let syntax = syntax.as(MemberTypeIdentifierSyntax.self) {
            self = .member(.init(syntax: syntax))
        } else if let syntax = syntax.as(TupleTypeSyntax.self) {
            self = .tuple(.init(syntax: syntax))
        } else if let syntax = syntax.as(FunctionTypeSyntax.self) {
            self = .function(.init(syntax: syntax))
        } else if let syntax = syntax.as(ArrayTypeSyntax.self) {
            self = .array(.init(syntax: syntax))
        } else if let syntax = syntax.as(DictionaryTypeSyntax.self) {
            self = .dictionary(.init(syntax: syntax))
        } else if let syntax = syntax.as(SomeTypeSyntax.self) {
            self = .some(.init(syntax: syntax))
        } else if let syntax = syntax.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
            self = .implicitlyUnwrappedOptional(.init(syntax: syntax))
        } else if let syntax = syntax.as(CompositionTypeSyntax.self) {
            self = .composition(.init(syntax: syntax))
        } else if let syntax = syntax.as(AttributedTypeSyntax.self) {
            self = .attributed(.init(syntax: syntax))
        } else if let syntax = syntax.as(MetatypeTypeSyntax.self) {
            self = .metatype(.init(syntax: syntax))
        } else if syntax.is(UnknownTypeSyntax.self) {
            self = .unknown
        } else {
            preconditionFailure("Unknown type syntax: \(syntax.syntaxNodeType)")
        }
    }

    public var description: String {
        switch self {
        case let .simple(node):
            return node.description
        case let .optional(node):
            return node.description
        case let .member(node):
            return node.description
        case let .tuple(node):
            return node.description
        case let .function(node):
            return node.description
        case let .array(node):
            return node.description
        case let .dictionary(node):
            return node.description
        case let .some(node):
            return node.description
        case let .implicitlyUnwrappedOptional(node):
            return node.description
        case let .composition(node):
            return node.description
        case let .attributed(node):
            return node.description
        case let .metatype(node):
            return node.description
        case .unknown:
            return "<UNKNOWN>"
        }
    }

    public static func parseList(_ syntax: GenericArgumentClauseSyntax?) -> [TypeNode] {
        return syntax?.arguments.map(\.argumentType).map(Self.init) ?? []
    }

    public static func parseList(_ syntax: CompositionTypeElementListSyntax) -> Set<TypeNode> {
        return Set(syntax.map(\.type).map(Self.init))
    }

    public static func parseList(_ syntax: TypeInheritanceClauseSyntax?) -> [TypeNode] {
        return syntax?.inheritedTypeCollection.map(\.typeName).map(Self.init) ?? []
    }
}

public struct SimpleTypeIdentifierNode: Equatable, Hashable, CustomStringConvertible {
    public var name: String
    public var genericArguments: [TypeNode]

    init(name: String, genericArguments: [TypeNode]) {
        self.name = name
        self.genericArguments = genericArguments
    }

    public init(syntax: SimpleTypeIdentifierSyntax) {
        self.name = syntax.name.text
        self.genericArguments = TypeNode.parseList(syntax.genericArgumentClause)
    }

    public var description: String {
        return name.appending(genericArguments) { "<\($0.map(\.description).commaSeparated())>" }
    }
}

public struct OptionalTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode

    public init(syntax: OptionalTypeSyntax) {
        self.type = TypeNode(syntax: syntax.wrappedType)
    }

    public var description: String {
        return "\(type)?"
    }
}

public struct MemberTypeIdentifierNode: Equatable, Hashable, CustomStringConvertible {
    public var parent: TypeNode
    public var name: String
    public var genericArguments: [TypeNode]

    public init(syntax: MemberTypeIdentifierSyntax) {
        self.parent = TypeNode(syntax: syntax.baseType)
        self.name = syntax.name.text
        self.genericArguments = TypeNode.parseList(syntax.genericArgumentClause)
    }

    public var description: String {
        return "\(parent).\(name)".appending(genericArguments) { "<\($0.map(\.description).commaSeparated())>" }
    }
}

public struct TupleTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var elements: [TupleTypeElementNode]

    public init(syntax: TupleTypeSyntax) {
        self.elements = TupleTypeElementNode.parseList(syntax.elements)
    }

    public var description: String {
        return "(\(elements.map(\.description).commaSeparated()))"
    }
}

public struct TupleTypeElementNode: Equatable, Hashable, CustomStringConvertible {
    public var inOut: Bool
    public var name: String?
//    public var secondName: String?
    public var type: TypeNode
    public var hasEllipsis: Bool
    public var initializer: ExprNode?

    public init(syntax: TupleTypeElementSyntax) {
        #warning("TODO: second name does not affect API, same for first name nil vs _")

        self.inOut = syntax.inOut != nil
        self.name = syntax.name?.text ?? "_"
//        self.secondName = syntax.secondName?.text
        self.type = TypeNode(syntax: syntax.type)
        self.hasEllipsis = syntax.ellipsis != nil
        self.initializer = (syntax.initializer?.value).map(ExprNode.init)
    }

    public var description: String {
        return ""
            .appending("inout ", if: inOut)
            .appending(name ?? "_")
            .appending(type) { ": \($0)" }
            .appending("...", if: hasEllipsis)
            .appending(initializer) { " = \($0)" }
    }

    public static func parseList(_ syntax: TupleTypeElementListSyntax) -> [TupleTypeElementNode] {
        return syntax.map(Self.init)
    }
}

public struct FunctionTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var arguments: [TupleTypeElementNode]
    public var async: Bool
    public var `throws`: ThrowsOrRethrowsNode?
    public var `return`: TypeNode

    public init(syntax: FunctionTypeSyntax) {
        self.arguments = TupleTypeElementNode.parseList(syntax.arguments)
        self.async = syntax.asyncKeyword != nil
        self.throws = syntax.throwsOrRethrowsKeyword.map(ThrowsOrRethrowsNode.init)
        self.return = TypeNode(syntax: syntax.returnType)
    }

    public var description: String {
        return "()"
            .appending(" async", if: async)
            .appending(`throws`) { " \($0)" }
            .appending(" -> \(`return`)")
    }
}

public struct ArrayTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var element: TypeNode

    public init(syntax: ArrayTypeSyntax) {
        self.element = TypeNode(syntax: syntax.elementType)
    }

    public var description: String {
        return "[\(element)]"
    }
}

public struct DictionaryTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var key: TypeNode
    public var value: TypeNode

    public init(syntax: DictionaryTypeSyntax) {
        self.key = TypeNode(syntax: syntax.keyType)
        self.value = TypeNode(syntax: syntax.valueType)
    }

    public var description: String {
        return "[\(key): \(value)]"
    }
}

public struct SomeTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode

    public init(syntax: SomeTypeSyntax) {
        self.type = TypeNode(syntax: syntax.baseType)
    }

    public var description: String {
        return "some \(type)"
    }
}

public struct ImplicitlyUnwrappedOptionalTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode

    public init(syntax: ImplicitlyUnwrappedOptionalTypeSyntax) {
        self.type = TypeNode(syntax: syntax.wrappedType)
    }

    public var description: String {
        return "\(type)!"
    }
}

public struct CompositionTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var types: Set<TypeNode>

    public init(syntax: CompositionTypeSyntax) {
        self.types = TypeNode.parseList(syntax.elements)
    }

    public var description: String {
        return types.map(\.description).sorted().joined(separator: " & ")
    }
}

public struct AttributedTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var specifier: SpecifierNode?
    public var attributes: Set<AttributeNode>
    public var type: TypeNode

    public init(syntax: AttributedTypeSyntax) {
        self.specifier = syntax.specifier.map(SpecifierNode.init) // inout?
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.type = TypeNode(syntax: syntax.baseType)
    }

    public var description: String {
        return ""
            .appending(specifier) { "\($0) " }
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending(type.description)
    }
}

public struct MetatypeTypeNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode
    public var typeOrProtocol: TypeOrProtocolNode

    public init(syntax: MetatypeTypeSyntax) {
        self.type = TypeNode(syntax: syntax.baseType)
        self.typeOrProtocol = TypeOrProtocolNode(syntax: syntax.typeOrProtocol)
    }

    public var description: String {
        return "\(type).\(typeOrProtocol)"
    }
}
