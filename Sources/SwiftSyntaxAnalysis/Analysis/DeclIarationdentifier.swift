import SwiftSyntax

public enum DeclarationIdentifier: Equatable, Hashable {
    case type(type: [String])
    case deinitializer(type: [String])
    case function(type: [String], name: String, parameters: [String?], static: Bool)
    case initializer(type: [String], parameters: [String?])
    case `subscript`(type: [String], indices: [String?], static: Bool)
    case variable(type: [String], name: String, static: Bool)

    public var parent: DeclarationIdentifier {
        switch self {
        case let .type(type):
            return .type(type: type.dropLast())
        case let .deinitializer(type):
            return .type(type: type)
        case let .function(type, _, _, _):
            return .type(type: type)
        case let .initializer(type, _):
            return .type(type: type)
        case let .subscript(type, _, _):
            return .type(type: type)
        case let .variable(type, _, _):
            return .type(type: type)
        }
    }
}

extension DeclarationIdentifier: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .type(type):
            return type.joined(separator: ".")
        case let .deinitializer(type):
            return "\(type.map({ "\($0)." }).joined())deinit"
        case let .function(type, name, parameters, `static`):
            return "\(type.map({ "\($0)." }).joined())\(name)(\(parameters.map({ "\($0 ?? "_"):" }).joined()))\(`static` ? " /* static */" : "")"
        case let .initializer(type, parameters):
            return "\(type.map({ "\($0)." }).joined())init(\(parameters.map({ "\($0 ?? "_"):" }).joined()))"
        case let .subscript(type, indices, `static`):
            return "\(type.map({ "\($0)." }).joined())subscript(\(indices.map({ "\($0 ?? "_"):" }).joined()))\(`static` ? " /* static */" : "")"
        case let .variable(type, name, `static`):
            return "\(type.map({ "\($0)." }).joined())\(name)\(`static` ? " /* static */" : "")"
        }
    }
}

extension DeclarationIdentifier: Comparable {
    public static func < (lhs: DeclarationIdentifier, rhs: DeclarationIdentifier) -> Bool {
        if lhs.typeName < rhs.typeName {
            return true
        } else if lhs.typeName > rhs.typeName {
            return false
        } else if lhs.declarationOrder < rhs.declarationOrder {
            return true
        } else if lhs.declarationOrder > rhs.declarationOrder {
            return false
        } else {
            return lhs.description < rhs.description
        }
    }

    public var type: [String] {
        switch self {
        case let .type(type),
             let .deinitializer(type),
             let .function(type, _, _, _),
             let .initializer(type, _),
             let .subscript(type, _, _),
             let .variable(type, _, _):
            return type
        }
    }

    public var typeName: String {
        return type.joined(separator: ".")
    }

    private var declarationOrder: Int {
        switch self {
        case .type:
            return 0
        case .variable(_, _, true):
            return 1
        case .subscript(_, _, true):
            return 2
        case .function(_, _, _, true):
            return 3
        case .initializer:
            return 4
        case .deinitializer:
            return 5
        case .variable(_, _, false):
            return 6
        case .subscript(_, _, false):
            return 7
        case .function(_, _, _, false):
            return 8
        }
    }
}
