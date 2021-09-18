import SwiftSyntax

public func collectDeclarations(from nodes: Set<DeclNode>, in module: String) -> [DeclarationIdentifier: Set<DeclNode>] {
    let collector = DeclarationCollector(module: module)
    collector.collectDeclarations(from: nodes)
    collector.mergeExtensions()
    return collector.declarations
}

fileprivate class DeclarationCollector {
    var scope: DeclarationScope
    var declarations: [DeclarationIdentifier: Set<DeclNode>] = [:]
    var extensions: [DeclarationIdentifier: Set<ExtensionDeclNode>] = [:]

    init(module: String) {
        self.scope = DeclarationScope(module: module)
    }

    func collectDeclarations(from nodes: Set<DeclNode>) {
        nodes.forEach(collectDeclarations)
    }

    func collectDeclarations(from node: DeclNode) {
        scope.push(node)

        defer {
            scope.pop(node)
        }

        switch node {
        case let .associatedtype(node):
            if shouldHandle(node.name, node.modifiers) {
                declarations[scope.current, default: []].insert(.associatedtype(node))
            }
        case var .class(node):
            if shouldHandle(node.name, node.modifiers) {
                collectDeclarations(from: node.members)
                node.members = []
                declarations[scope.current, default: []].insert(.class(node))
            }
        case let .deinitializer(node):
            declarations[scope.current, default: []].insert(.deinitializer(node))
        case var .enum(node):
            if shouldHandle(node.name, node.modifiers) {
                collectDeclarations(from: node.members)
                node.members = []
                declarations[scope.current, default: []].insert(.enum(node))
            }
        case let .enumCase(node):
            if shouldHandle(node.name, node.modifiers) {
                declarations[scope.current, default: []].insert(.enumCase(node))
            }
        case var .extension(node):
            if shouldHandle(node.type) {
                #warning("TODO: push extension accessibility to members")
                #warning("TODO: push extension generic constraints to members")
                collectDeclarations(from: node.members)

                if !node.inherits.isEmpty {
                    node.members = []
                    extensions[scope.current, default: []].insert(node)
                }
            }
        case let .function(node):
            if shouldHandle(node.name, node.modifiers) {
                declarations[scope.current, default: []].insert(.function(node))
            }
        case let .initializer(node):
            if shouldHandle(node.parameters.first?.name ?? "", node.modifiers) {
                declarations[scope.current, default: []].insert(.initializer(node))
            }
        case var .protocol(node):
            if shouldHandle(node.name, node.modifiers) {
                collectDeclarations(from: node.members)
                node.members = []
                declarations[scope.current, default: []].insert(.protocol(node))
            }
        case var .struct(node):
            if shouldHandle(node.name, node.modifiers) {
                collectDeclarations(from: node.members)
                node.members = []
                declarations[scope.current, default: []].insert(.struct(node))
            }
        case let .subscript(node):
            if shouldHandle(node.indices.first?.name ?? "", node.modifiers) {
                declarations[scope.current, default: []].insert(.subscript(node))
            }
        case let .typealias(node):
            if shouldHandle(node.name, node.modifiers) {
                declarations[scope.current, default: []].insert(.typealias(node))
            }
        case let .variable(node):
            if shouldHandle(node.pattern, node.modifiers) {
                declarations[scope.current, default: []].insert(.variable(node))
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

    func mergeExtensions() {
        for (identifier, extensions) in extensions {
            guard declarations[identifier, default: []].count <= 1 else {
                preconditionFailure()
            }

            switch declarations[identifier, default: []].first {
            case var .some(.class(node)):
                node.inherits.appendUnique(from: extensions.flatMap(\.inherits))
                declarations[identifier] = [.class(node)]

            case var .some(.enum(node)):
                node.inherits.appendUnique(from: extensions.flatMap(\.inherits))
                declarations[identifier] = [.enum(node)]

            case var .some(.protocol(node)):
                node.inherits.appendUnique(from: extensions.flatMap(\.inherits))
                declarations[identifier] = [.protocol(node)]

            case var .some(.struct(node)):
                node.inherits.appendUnique(from: extensions.flatMap(\.inherits))
                declarations[identifier] = [.struct(node)]

            case .none:
                declarations[identifier, default: []].formUnion(extensions.map(DeclNode.extension))

            case .some(.associatedtype),
                 .some(.deinitializer),
                 .some(.enumCase),
                 .some(.extension),
                 .some(.function),
                 .some(.initializer),
                 .some(.subscript),
                 .some(.typealias),
                 .some(.variable),
                 .some(.ifConfig),
                 .some(.import),
                 .some(.operator),
                 .some(.poundError),
                 .some(.poundWarning),
                 .some(.precedenceGroup),
                 .some(.unknown):
                preconditionFailure()
            }
        }
    }

    private func shouldHandle(_ name: String, _ modifiers: Set<ModifierNode>) -> Bool {
        return !name.hasPrefix("_") && modifiers.isPublic
    }

    private func shouldHandle(_ type: TypeNode) -> Bool {
        switch type {
        case let .simple(type):
            return shouldHandle(type.name, [])
        case let .member(type):
            return shouldHandle(type.name, []) && shouldHandle(type.parent)
        default:
            preconditionFailure()
        }
    }

    private func shouldHandle(_ pattern: PatternNode, _ modifiers: Set<ModifierNode>) -> Bool {
        if case let .identifier(pattern) = pattern {
            return shouldHandle(pattern.name, modifiers)
        } else {
            preconditionFailure()
        }
    }
}

private extension Set where Element == ModifierNode {
    var isPublic: Bool {
        return !intersection([.open, .public]).isEmpty
    }
}

extension Array where Element: Hashable {
    mutating func appendUnique<S>(from other: S) where S: Sequence, S.Element == Element {
        for element in other where !contains(element) {
            append(element)
        }
    }
}
