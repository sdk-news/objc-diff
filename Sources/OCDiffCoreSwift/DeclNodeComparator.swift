import Foundation
import OCDiffCore
import SwiftSyntaxAnalysis

enum DeclNodeComparator {
    static func modifications(from old: DeclNode, to new: DeclNode) -> [OCDModification] {
        switch (old, new) {
        case let (.`associatedtype`(old), .`associatedtype`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`class`(old), .`class`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.deinitializer(old), .deinitializer(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`enum`(old), .`enum`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`enumCase`(old), .`enumCase`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`extension`(old), .`extension`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.function(old), .function(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`ifConfig`(old), .`ifConfig`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`import`(old), .`import`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.initializer(old), .initializer(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`operator`(old), .`operator`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.poundError(old), .poundError(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.poundWarning(old), .poundWarning(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.precedenceGroup(old), .precedenceGroup(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`protocol`(old), .`protocol`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`struct`(old), .`struct`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`subscript`(old), .`subscript`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.`typealias`(old), .`typealias`(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()
        case let (.variable(old), .variable(new)):
            return DeclNodeComparatorImpl(from: old, to: new).modifications()

        default:
            precondition(
                old.discriminator == .unknown || old.discriminator != new.discriminator,
                "Smart diff not implemented for \(old.discriminator)"
            )

            return [
                OCDModification(
                    type: .declaration,
                    previousValue: old.discriminator.rawValue,
                    currentValue: new.discriminator.rawValue
                ),
                OCDModification(
                    type: .replacement,
                    previousValue: old.description,
                    currentValue: new.description
                )
            ]
        }
    }
}

// MARK: -

fileprivate class DeclNodeComparatorImpl<Node> where Node: Equatable & CustomStringConvertible {
    var old: Node
    var new: Node

    init(from old: Node, to new: Node) {
        self.old = old
        self.new = new
    }

    func modifications() -> [OCDModification] {
        let oldOriginal = old
        let newOriginal = new

        defer {
            old = oldOriginal
            new = newOriginal
        }

        var result: [OCDModification] = []

        if let comparator = self as? DeclNodeComparatorWithAttributes {
            result.append(contentsOf: comparator.modificationsFromAttributes())
        }

        if let comparator = self as? DeclNodeComparatorWithInherits {
            result.append(contentsOf: comparator.modificationsFromInherits())
        }

        if old != new {
            result.append(
                OCDModification(
                    type: .replacement,
                    previousValue: oldOriginal.description,
                    currentValue: newOriginal.description
                )
            )
        }

        return result
    }
}

// MARK: -

fileprivate protocol DeclNodeComparatorWithAttributes {
    func modificationsFromAttributes() -> [OCDModification]
}

extension DeclNodeComparatorImpl: DeclNodeComparatorWithAttributes where Node: DeclNodeWithAttributes {
    fileprivate func modificationsFromAttributes() -> [OCDModification] {
        guard old.attributes != new.attributes else {
            return []
        }

        let oldGrouped = Dictionary(grouping: old.attributes, by: \.name).mapValues(Set.init)
        let newGrouped = Dictionary(grouping: new.attributes, by: \.name).mapValues(Set.init)
        let oldAttributes = Set(oldGrouped.keys)
        let newAttributes = Set(newGrouped.keys)

        old.attributes = []
        new.attributes = []

        var result: [OCDModification] = []

        result.append(
            contentsOf: oldAttributes.subtracting(newAttributes).map {
                OCDModification(
                    type: .replacement,
                    previousValue: oldGrouped[$0]!.map(\.description).sorted().joined(separator: "\n"),
                    currentValue: ""
                )
            }
        )

        result.append(
            contentsOf: newAttributes.subtracting(oldAttributes).map {
                OCDModification(
                    type: .replacement,
                    previousValue: "",
                    currentValue: newGrouped[$0]!.map(\.description).sorted().joined(separator: "\n")
                )
            }
        )

        result.append(
            contentsOf: newAttributes.intersection(oldAttributes).filter({ oldGrouped[$0] != newGrouped[$0] }).map {
                OCDModification(
                    type: .replacement,
                    previousValue: oldGrouped[$0]!.map(\.description).sorted().joined(separator: "\n"),
                    currentValue: newGrouped[$0]!.map(\.description).sorted().joined(separator: "\n")
                )
            }
        )

        return result
    }
}

fileprivate protocol DeclNodeComparatorWithInherits {
    func modificationsFromInherits() -> [OCDModification]
}

extension DeclNodeComparatorImpl: DeclNodeComparatorWithInherits where Node: DeclNodeWithInherits {
    fileprivate func modificationsFromInherits() -> [OCDModification] {
        guard old.inherits != new.inherits else {
            return []
        }

        let oldInherits = Set(old.inherits)
        let newInherits = Set(new.inherits)

        old.inherits = []
        new.inherits = []

        return [
            OCDModification(
                type: .protocols,
                previousValue: oldInherits.subtracting(newInherits).map(\.description).sorted().joined(separator: ", "),
                currentValue: newInherits.subtracting(oldInherits).map(\.description).sorted().joined(separator: ", ")
            )
        ]
    }
}

// MARK: -

fileprivate protocol DeclNodeWithAttributes {
    var attributes: Set<AttributeNode> { get set }
}

fileprivate protocol DeclNodeWithInherits {
    var inherits: [TypeNode] { get set }
}

// MARK: -

extension AssociatedtypeDeclNode: DeclNodeWithAttributes, DeclNodeWithInherits {}
extension ClassDeclNode: DeclNodeWithAttributes, DeclNodeWithInherits {}
extension DeinitializerDeclNode: DeclNodeWithAttributes {}
extension EnumDeclNode: DeclNodeWithAttributes, DeclNodeWithInherits {}
extension EnumCaseDeclNode: DeclNodeWithAttributes {}
extension ExtensionDeclNode: DeclNodeWithAttributes, DeclNodeWithInherits {}
extension FunctionDeclNode: DeclNodeWithAttributes {}
extension IfConfigDeclNode {}
extension ImportDeclNode {}
extension InitializerDeclNode: DeclNodeWithAttributes {}
extension OperatorDeclNode {}
extension PoundErrorDeclNode {}
extension PoundWarningDeclNode {}
extension PrecedenceGroupDeclNode {}
extension ProtocolDeclNode: DeclNodeWithAttributes, DeclNodeWithInherits {}
extension StructDeclNode: DeclNodeWithAttributes, DeclNodeWithInherits {}
extension SubscriptDeclNode: DeclNodeWithAttributes {}
extension TypealiasDeclNode: DeclNodeWithAttributes {}
extension VariableDeclNode: DeclNodeWithAttributes {}
