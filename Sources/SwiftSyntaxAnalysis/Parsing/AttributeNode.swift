import SwiftSyntax

public enum AttributeNode: Equatable, Hashable, CustomStringConvertible {
    case attribute(StandardAttributeNode)
    case customAttribute(CustomAttributeNode)

    public init(syntax: Syntax) {
        if let syntax = syntax.as(AttributeSyntax.self) {
            self = .attribute(.init(syntax: syntax))
        } else if let syntax = syntax.as(CustomAttributeSyntax.self) {
            self = .customAttribute(.init(syntax: syntax))
        } else {
            preconditionFailure("Unknown attribute syntax: \(syntax.syntaxNodeType)")
        }
    }

    public var description: String {
        switch self {
        case let .attribute(node):
            return node.description
        case let .customAttribute(node):
            return node.description
        }
    }

    public static func parseList(_ syntax: AttributeListSyntax?) -> Set<AttributeNode> {
        return Set(syntax?.map(Self.init) ?? [])
    }
}

extension AttributeNode {
    public var name: String {
        switch self {
        case let .attribute(standardAttributeNode):
            return standardAttributeNode.name
        case let .customAttribute(customAttributeNode):
            return customAttributeNode.type.description
        }
    }
}

public struct StandardAttributeNode: Equatable, Hashable, CustomStringConvertible {
    public var name: String
    public var argument: OpaqueNode?

    public init(syntax: AttributeSyntax) {
        self.name = syntax.attributeName.text
        self.argument = syntax.argument.map(OpaqueNode.init)
        assert(syntax.tokenList == nil)
    }

    public var description: String {
        return "@\(name)".appending(argument) { "(\($0))" }
    }
}

public struct CustomAttributeNode: Equatable, Hashable, CustomStringConvertible {
    public var type: TypeNode
    public var arguments: [ArgumentNode]

    public init(syntax: CustomAttributeSyntax) {
        self.type = TypeNode(syntax: syntax.attributeName)
        self.arguments = ArgumentNode.parseList(syntax.argumentList)
    }

    public var description: String {
        return "@\(type.description)".appending(arguments) { "(\($0.map(\.description).commaSeparated()))" }
    }
}
