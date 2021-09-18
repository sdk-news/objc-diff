import SwiftSyntax

struct DeclarationScope {
    let module: String
    var current: DeclarationIdentifier = .type(type: [])

    init(module: String) {
        self.module = module
    }

    mutating func push(_ node: DeclNode) {
        switch (current, node) {
        case let (.type(type), .associatedtype(node)):
            current = .type(type: type + [node.name])
        case let (.type(type), .class(node)):
            current = .type(type: type + [node.name])
        case let (.type(type), .deinitializer):
            current = .deinitializer(type: type)
        case let (.type(type), .enum(node)):
            current = .type(type: type + [node.name])
        case let (.type(type), .enumCase(node)):
            current = .function(type: type, name: node.name, parameters: node.associatedValue.map(\.name), static: true)
        case let (.type([]), .extension(node)):
            current = .type(type: typeComponents(for: node.type))
        case let (.type(type), .function(node)):
            current = .function(type: type, name: node.name, parameters: node.parameters.map(\.name), static: node.modifiers.isStatic)
        case let (.type(type), .initializer(node)):
            current = .initializer(type: type, parameters: node.parameters.map(\.name))
        case let (.type(type), .protocol(node)):
            current = .type(type: type + [node.name])
        case let (.type(type), .struct(node)):
            current = .type(type: type + [node.name])
        case let (.type(type), .subscript(node)):
            current = .subscript(type: type, indices: node.indices.map(\.name), static: node.modifiers.isStatic)
        case let (.type(type), .typealias(node)):
            current = .type(type: type + [node.name])
        case let (.type(type), .variable(node)):
            if case let .identifier(pattern) = node.pattern {
                current = .variable(type: type, name: pattern.name, static: node.modifiers.isStatic)
            } else {
                preconditionFailure()
            }

        case (_, .ifConfig),
             (_, .import),
             (_, .operator),
             (_, .poundError),
             (_, .poundWarning),
             (_, .precedenceGroup),
             (_, .unknown):
            break

        default:
            preconditionFailure()
        }
    }

    mutating func pop(_ node: DeclNode) {
        switch node {
        case .extension:
            current = .type(type: [])

        case .associatedtype,
             .class,
             .deinitializer,
             .enum,
             .enumCase,
             .function,
             .initializer,
             .protocol,
             .struct,
             .subscript,
             .typealias:
            current = current.parent

        case let .variable(node):
            if case .identifier = node.pattern {
                current = current.parent
            } else {
                preconditionFailure()
            }

        case .ifConfig,
             .import,
             .operator,
             .poundError,
             .poundWarning,
             .precedenceGroup,
             .unknown:
            break
        }
    }

    private func typeComponents(for node: TypeNode) -> [String] {
        switch node {
        case let .simple(node) where node.name == module:
            return []
        case let .simple(node):
            return [node.name]
        case let .member(node):
            return typeComponents(for: node.parent) + [node.name]

        case .array,
             .attributed,
             .composition,
             .dictionary,
             .function,
             .implicitlyUnwrappedOptional,
             .metatype,
             .optional,
             .some,
             .tuple,
             .unknown:
            preconditionFailure()
        }
    }
}

private extension Set where Element == ModifierNode {
    var isStatic: Bool {
        return !intersection([.class, .static]).isEmpty
    }
}
