import SwiftSyntax

public enum DeclNode: Equatable, Hashable, CustomStringConvertible {
    case `associatedtype`(AssociatedtypeDeclNode)
    case `class`(ClassDeclNode)
    case deinitializer(DeinitializerDeclNode)
    case `enum`(EnumDeclNode)
    case `enumCase`(EnumCaseDeclNode)
    case `extension`(ExtensionDeclNode)
    case function(FunctionDeclNode)
    case `ifConfig`(IfConfigDeclNode)
    case `import`(ImportDeclNode)
    case initializer(InitializerDeclNode)
    case `operator`(OperatorDeclNode)
    case poundError(PoundErrorDeclNode)
    case poundWarning(PoundWarningDeclNode)
    case precedenceGroup(PrecedenceGroupDeclNode)
    case `protocol`(ProtocolDeclNode)
    case `struct`(StructDeclNode)
    case `subscript`(SubscriptDeclNode)
    case `typealias`(TypealiasDeclNode)
    case variable(VariableDeclNode)
    case unknown

    public static func parseList(_ syntax: DeclSyntax) -> Set<DeclNode> {
        if let syntax = syntax.as(AssociatedtypeDeclSyntax.self) {
            return [.associatedtype(.init(syntax: syntax))]
        } else if let syntax = syntax.as(ClassDeclSyntax.self) {
            return [.class(.init(syntax: syntax))]
        } else if let syntax = syntax.as(DeinitializerDeclSyntax.self) {
            return [.deinitializer(.init(syntax: syntax))]
        } else if let syntax = syntax.as(EnumDeclSyntax.self) {
            return [.enum(.init(syntax: syntax))]
        } else if let syntax = syntax.as(EnumCaseDeclSyntax.self) {
            return Set(EnumCaseDeclNode.parseList(syntax).map(enumCase))
        } else if let syntax = syntax.as(ExtensionDeclSyntax.self) {
            return [.extension(.init(syntax: syntax))]
        } else if let syntax = syntax.as(FunctionDeclSyntax.self) {
            return [.function(.init(syntax: syntax))]
        } else if let syntax = syntax.as(IfConfigDeclSyntax.self) {
            return [.ifConfig(.init(syntax: syntax))]
        } else if let syntax = syntax.as(ImportDeclSyntax.self) {
            return [.import(.init(syntax: syntax))]
        } else if let syntax = syntax.as(InitializerDeclSyntax.self) {
            return [.initializer(.init(syntax: syntax))]
        } else if let syntax = syntax.as(OperatorDeclSyntax.self) {
            return [.operator(.init(syntax: syntax))]
        } else if let syntax = syntax.as(PoundErrorDeclSyntax.self) {
            return [.poundError(.init(syntax: syntax))]
        } else if let syntax = syntax.as(PoundWarningDeclSyntax.self) {
            return [.poundWarning(.init(syntax: syntax))]
        } else if let syntax = syntax.as(PrecedenceGroupDeclSyntax.self) {
            return [.precedenceGroup(.init(syntax: syntax))]
        } else if let syntax = syntax.as(ProtocolDeclSyntax.self) {
            return [.protocol(.init(syntax: syntax))]
        } else if let syntax = syntax.as(StructDeclSyntax.self) {
            return [.struct(.init(syntax: syntax))]
        } else if let syntax = syntax.as(SubscriptDeclSyntax.self) {
            return [.subscript(.init(syntax: syntax))]
        } else if let syntax = syntax.as(TypealiasDeclSyntax.self) {
            return [.typealias(.init(syntax: syntax))]
        } else if let syntax = syntax.as(VariableDeclSyntax.self) {
            return Set(VariableDeclNode.parseList(syntax).map(variable))
        } else if syntax.is(UnknownDeclSyntax.self) {
            return [.unknown]
        } else {
            preconditionFailure("Unknown declaration syntax: \(syntax.syntaxNodeType)")
        }
    }

    public var description: String {
        switch self {
        case let .associatedtype(node):
            return node.description
        case let .class(node):
            return node.description
        case let .deinitializer(node):
            return node.description
        case let .enum(node):
            return node.description
        case let .enumCase(node):
            return node.description
        case let .extension(node):
            return node.description
        case let .function(node):
            return node.description
        case let .ifConfig(node):
            return node.description
        case let .import(node):
            return node.description
        case let .initializer(node):
            return node.description
        case let .operator(node):
            return node.description
        case let .poundError(node):
            return node.description
        case let .poundWarning(node):
            return node.description
        case let .precedenceGroup(node):
            return node.description
        case let .protocol(node):
            return node.description
        case let .struct(node):
            return node.description
        case let .subscript(node):
            return node.description
        case let .typealias(node):
            return node.description
        case let .variable(node):
            return node.description
        case .unknown:
            return "<UNKNOWN>"
        }
    }

    public static func parseList(_ syntax: MemberDeclBlockSyntax) -> Set<DeclNode> {
        return syntax.members.map(\.decl).map(Self.parseList).reduce([]) { $0.union($1) }
    }

    public static func parseList(_ syntax: SourceFileSyntax) -> Set<DeclNode> {
        return Set(syntax.statements.compactMap({ $0.item.as(DeclSyntax.self) }).flatMap(Self.parseList))
    }
}

extension DeclNode {
    public var discriminator: Discriminator {
        switch self {
        case .`associatedtype`:
            return .`associatedtype`
        case .`class`:
            return .`class`
        case .deinitializer:
            return .deinitializer
        case .`enum`:
            return .`enum`
        case .`enumCase`:
            return .`enumCase`
        case .`extension`:
            return .`extension`
        case .function:
            return .function
        case .`ifConfig`:
            return .`ifConfig`
        case .`import`:
            return .`import`
        case .initializer:
            return .initializer
        case .`operator`:
            return .`operator`
        case .poundError:
            return .poundError
        case .poundWarning:
            return .poundWarning
        case .precedenceGroup:
            return .precedenceGroup
        case .`protocol`:
            return .`protocol`
        case .`struct`:
            return .`struct`
        case .`subscript`:
            return .`subscript`
        case .`typealias`:
            return .`typealias`
        case .variable:
            return .variable
        case .unknown:
            return .unknown
        }
    }
    public enum Discriminator: String, Hashable {
        case `associatedtype`
        case `class`
        case deinitializer
        case `enum`
        case `enumCase`
        case `extension`
        case function
        case `ifConfig`
        case `import`
        case initializer
        case `operator`
        case poundError
        case poundWarning
        case precedenceGroup
        case `protocol`
        case `struct`
        case `subscript`
        case `typealias`
        case variable
        case unknown
    }
}

public struct AccessorDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifier: ModifierNode?
    public var kind: AccessorKindNode

    private init(implicitGetter: Void) {
        self.attributes = []
        self.modifier = nil
        self.kind = .get
    }

    public init(syntax: AccessorDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifier = syntax.modifier.map(ModifierNode.init)
        self.kind = AccessorKindNode(syntax: syntax.accessorKind)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifier) { "\($0) " }
            .appending(kind.description)
    }

    public static func parseList(_ syntax: AccessorBlockSyntax) -> Set<AccessorDeclNode> {
        return Set(syntax.accessors.map(Self.init))
    }

    public static func parseList(_ syntax: Syntax?) -> Set<AccessorDeclNode> {
        if let syntax = syntax?.as(AccessorBlockSyntax.self) {
            return parseList(syntax)
        } else if syntax != nil {
            return [AccessorDeclNode(implicitGetter: ())]
        } else {
            return []
        }
    }
}

public struct AssociatedtypeDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var inherits: [TypeNode]
    public var `default`: TypeNode?
    public var genericRequirements: Set<GenericRequirementNode>

    public init(syntax: AssociatedtypeDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = syntax.identifier.text
        self.inherits = TypeNode.parseList(syntax.inheritanceClause)
        self.default = (syntax.initializer?.value).map(TypeNode.init)
        self.genericRequirements = GenericRequirementNode.parseList(whereClause: syntax.genericWhereClause)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("associatedtype \(name)")
            .appending(inherits) { ": \($0.map(\.description).commaSeparated())" }
            .appending(`default`) { " = \($0)" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct ClassDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var genericParameters: [String]
    public var inherits: [TypeNode]
    public var genericRequirements: Set<GenericRequirementNode>
    public var members: Set<DeclNode>

    public init(syntax: ClassDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = syntax.identifier.text
        self.genericParameters = String.parseList(syntax.genericParameterClause)
        self.inherits = TypeNode.parseList(syntax.inheritanceClause)
        self.genericRequirements = GenericRequirementNode.parseList(parameterList: syntax.genericParameterClause, whereClause: syntax.genericWhereClause)
        self.members = DeclNode.parseList(syntax.members)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("class \(name)")
            .appending(genericParameters) { "<\($0.commaSeparated())>" }
            .appending(inherits) { ": \($0.map(\.description).commaSeparated())" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct DeinitializerDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>

    public init(syntax: DeinitializerDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("deinit")
    }
}

public struct EnumDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var genericParameters: [String]
    public var inherits: [TypeNode]
    public var genericRequirements: Set<GenericRequirementNode>
    public var members: Set<DeclNode>

    public init(syntax: EnumDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = syntax.identifier.text
        self.genericParameters = String.parseList(syntax.genericParameters)
        self.inherits = TypeNode.parseList(syntax.inheritanceClause)
        self.genericRequirements = GenericRequirementNode.parseList(parameterList: syntax.genericParameters, whereClause: syntax.genericWhereClause)
        self.members = DeclNode.parseList(syntax.members)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("enum \(name)")
            .appending(genericParameters) { "<\($0.commaSeparated())>" }
            .appending(inherits) { ": \($0.map(\.description).commaSeparated())" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct EnumCaseDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var associatedValue: [FunctionParameterNode]
    public var rawValue: ExprNode?

    public init(syntax: EnumCaseDeclSyntax, element: EnumCaseElementSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = element.identifier.text
        self.associatedValue = FunctionParameterNode.parseList(element.associatedValue)
        self.rawValue = (element.rawValue?.value).map(ExprNode.init)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("case \(name)")
            .appending(associatedValue) { "(\($0.map(\.description).commaSeparated()))" }
            .appending(rawValue) { " = \($0)" }
    }

    public static func parseList(_ syntax: EnumCaseDeclSyntax) -> Set<EnumCaseDeclNode> {
        return Set(syntax.elements.map({ EnumCaseDeclNode(syntax: syntax, element: $0) }))
    }
}

public struct ExtensionDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var type: TypeNode
    public var inherits: [TypeNode]
    public var genericRequirements: Set<GenericRequirementNode>
    public var members: Set<DeclNode>

    public init(syntax: ExtensionDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.type = TypeNode(syntax: syntax.extendedType)
        self.inherits = TypeNode.parseList(syntax.inheritanceClause)
        self.genericRequirements = GenericRequirementNode.parseList(whereClause: syntax.genericWhereClause)
        self.members = DeclNode.parseList(syntax.members)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("extension \(type)")
            .appending(inherits) { ": \($0.map(\.description).commaSeparated())" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct FunctionDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var genericParameters: [String]
    public var parameters: [FunctionParameterNode]
    public var async: AsyncOrReasyncNode?
    public var `throws`: ThrowsOrRethrowsNode?
    public var `return`: TypeNode?
    public var genericRequirements: Set<GenericRequirementNode>

    public init(syntax: FunctionDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = syntax.identifier.text
        self.genericParameters = String.parseList(syntax.genericParameterClause)
        self.parameters = FunctionParameterNode.parseList(syntax.signature.input)
        self.async = syntax.signature.asyncOrReasyncKeyword.map(AsyncOrReasyncNode.init)
        self.throws = syntax.signature.throwsOrRethrowsKeyword.map(ThrowsOrRethrowsNode.init)
        self.return = (syntax.signature.output?.returnType).map(TypeNode.init)
        self.genericRequirements = GenericRequirementNode.parseList(parameterList: syntax.genericParameterClause, whereClause: syntax.genericWhereClause)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("func \(name)")
            .appending(genericParameters) { "<\($0.commaSeparated())>" }
            .appending("(\(parameters.map(\.description).commaSeparated()))")
            .appending(async) { " \($0)" }
            .appending(`throws`) { " \($0)" }
            .appending(`return`) { " -> \($0)" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct FunctionParameterNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var name: String?
//    public var internalName: String?
    public var type: TypeNode?
    public var hasEllipsis: Bool
    public var `default`: ExprNode?

    public init(syntax: FunctionParameterSyntax) {
        #warning("TODO: second name does not affect API, same for first name nil vs _")

        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.name = syntax.firstName?.text ?? "_"
//        self.internalName = syntax.secondName?.text
        self.type = syntax.type.map(TypeNode.init)
        self.hasEllipsis = syntax.ellipsis != nil
        self.default = (syntax.defaultArgument?.value).map(ExprNode.init)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(name ?? "_")
            .appending(type) { ": \($0)" }
            .appending("...", if: hasEllipsis)
            .appending(`default`) { " = \($0)" }
    }

    public static func parseList(_ syntax: ParameterClauseSyntax?) -> [FunctionParameterNode] {
        return syntax?.parameterList.map(Self.init) ?? []
    }
}

public struct IfConfigDeclNode: Equatable, Hashable, CustomStringConvertible {
    #warning("TODO: not implemented")

    public init(syntax: IfConfigDeclSyntax) {}
    public var description: String { fatalError() }
}

public struct ImportDeclNode: Equatable, Hashable, CustomStringConvertible {
    #warning("TODO: not implemented")

    public init(syntax: ImportDeclSyntax) {}
    public var description: String { fatalError() }
}

public struct InitializerDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var optional: Bool
    public var genericParameters: [String]
    public var parameters: [FunctionParameterNode]
    public var `throws`: ThrowsOrRethrowsNode?
    public var genericRequirements: Set<GenericRequirementNode>

    public init(syntax: InitializerDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.optional = syntax.optionalMark != nil
        self.genericParameters = String.parseList(syntax.genericParameterClause)
        self.parameters = FunctionParameterNode.parseList(syntax.parameters)
        self.throws = syntax.throwsOrRethrowsKeyword.map(ThrowsOrRethrowsNode.init)
        self.genericRequirements = GenericRequirementNode.parseList(parameterList: syntax.genericParameterClause, whereClause: syntax.genericWhereClause)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("init")
            .appending("?", if: optional)
            .appending(genericParameters) { "<\($0.commaSeparated())>" }
            .appending("(\(parameters.map(\.description).commaSeparated()))")
            .appending(`throws`) { " \($0)" }
    }
}

public struct OperatorDeclNode: Equatable, Hashable, CustomStringConvertible {
    #warning("TODO: not implemented")

    public init(syntax: OperatorDeclSyntax) {}
    public var description: String { fatalError() }
}

public struct PoundErrorDeclNode: Equatable, Hashable, CustomStringConvertible {
    #warning("TODO: not implemented")

    public init(syntax: PoundErrorDeclSyntax) {}
    public var description: String { fatalError() }
}

public struct PoundWarningDeclNode: Equatable, Hashable, CustomStringConvertible {
    #warning("TODO: not implemented")

    public init(syntax: PoundWarningDeclSyntax) {}
    public var description: String { fatalError() }
}

public struct PrecedenceGroupDeclNode: Equatable, Hashable, CustomStringConvertible {
    #warning("TODO: not implemented")

    public init(syntax: PrecedenceGroupDeclSyntax) {}
    public var description: String { fatalError() }
}

public struct ProtocolDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var inherits: [TypeNode]
    public var genericRequirements: Set<GenericRequirementNode>
    public var members: Set<DeclNode>

    public init(syntax: ProtocolDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = syntax.identifier.text
        self.inherits = TypeNode.parseList(syntax.inheritanceClause)
        self.genericRequirements = GenericRequirementNode.parseList(whereClause: syntax.genericWhereClause)
        self.members = DeclNode.parseList(syntax.members)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("protocol \(name)")
            .appending(inherits) { ": \($0.map(\.description).commaSeparated())" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct StructDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var genericParameters: [String]
    public var inherits: [TypeNode]
    public var genericRequirements: Set<GenericRequirementNode>
    public var members: Set<DeclNode>

    public init(syntax: StructDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = syntax.identifier.text
        self.genericParameters = String.parseList(syntax.genericParameterClause)
        self.inherits = TypeNode.parseList(syntax.inheritanceClause)
        self.genericRequirements = GenericRequirementNode.parseList(parameterList: syntax.genericParameterClause, whereClause: syntax.genericWhereClause)
        self.members = DeclNode.parseList(syntax.members)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("struct \(name)")
            .appending(genericParameters) { "<\($0.commaSeparated())>" }
            .appending(inherits) { ": \($0.map(\.description).commaSeparated())" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct SubscriptDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var genericParameters: [String]
    public var indices: [FunctionParameterNode]
    public var result: TypeNode?
    public var genericRequirements: Set<GenericRequirementNode>
    public var accessors: Set<AccessorDeclNode>

    public init(syntax: SubscriptDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.genericParameters = String.parseList(syntax.genericParameterClause)
        self.indices = FunctionParameterNode.parseList(syntax.indices)
        self.result = TypeNode(syntax: syntax.result.returnType)
        self.genericRequirements = GenericRequirementNode.parseList(parameterList: syntax.genericParameterClause, whereClause: syntax.genericWhereClause)
        self.accessors = AccessorDeclNode.parseList(syntax.accessor)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("subscript")
            .appending(genericParameters) { "<\($0.commaSeparated())>" }
            .appending("(\(indices.map(\.description).commaSeparated()))")
            .appending(result) { " -> \($0)" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct TypealiasDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var name: String
    public var genericParameters: [String]
    public var type: TypeNode?
    public var genericRequirements: Set<GenericRequirementNode>

    public init(syntax: TypealiasDeclSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.name = syntax.identifier.text
        self.genericParameters = String.parseList(syntax.genericParameterClause)
        self.type = (syntax.initializer?.value).map(TypeNode.init)
        self.genericRequirements = GenericRequirementNode.parseList(parameterList: syntax.genericParameterClause, whereClause: syntax.genericWhereClause)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("typealias \(name)")
            .appending(genericParameters) { "<\($0.commaSeparated())>" }
            .appending(type) { " = \($0)" }
            .appending(genericRequirements) { " where \($0.map(\.description).sorted().commaSeparated())" }
    }
}

public struct VariableDeclNode: Equatable, Hashable, CustomStringConvertible {
    public var attributes: Set<AttributeNode>
    public var modifiers: Set<ModifierNode>
    public var letOrVar: LetOrVarNode
    public var pattern: PatternNode
    public var type: TypeNode?
    public var initializer: ExprNode?
    public var accessors: Set<AccessorDeclNode>

    public init(syntax: VariableDeclSyntax, binding: PatternBindingSyntax) {
        self.attributes = AttributeNode.parseList(syntax.attributes)
        self.modifiers = ModifierNode.parseList(syntax.modifiers)
        self.letOrVar = LetOrVarNode(syntax: syntax.letOrVarKeyword)
        self.pattern = PatternNode(syntax: binding.pattern)
        self.type = (binding.typeAnnotation?.type).map(TypeNode.init)
        self.initializer = (binding.initializer?.value).map(ExprNode.init)
        self.accessors = AccessorDeclNode.parseList(binding.accessor)
    }

    public var description: String {
        return ""
            .appending(attributes) { "\($0.map(\.description).sorted().joined(separator: "\n"))\n" }
            .appending(modifiers) { "\($0.map(\.description).sorted().joined(separator: " ")) " }
            .appending("\(letOrVar) \(pattern)")
            .appending(type) { ": \($0)" }
            .appending(initializer) { " = \($0)" }
            .appending(accessors) { " { \($0.map(\.description).sorted().joined(separator: " ")) }" }
    }

    public static func parseList(_ syntax: VariableDeclSyntax) -> Set<VariableDeclNode> {
        return Set(syntax.bindings.map({ VariableDeclNode(syntax: syntax, binding: $0) }))
    }
}
