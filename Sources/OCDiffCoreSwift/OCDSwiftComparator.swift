import Foundation
import OCDiffCore
import SwiftSyntax
import SwiftSyntaxParser
import SwiftSyntaxAnalysis

@objc public class OCDSwiftInterfaceComparator: NSObject {
    @objc public class func compareModule(_ moduleName: String, oldInterfaceURL: URL?, newInterfaceURL: URL?) -> [OCDifference]? {
        do {
            let oldDecls = try loadDeclarationSet(from: oldInterfaceURL, moduleName: moduleName)
            let newDecls = try loadDeclarationSet(from: newInterfaceURL, moduleName: moduleName)

            return compareDeclarationSets(old: oldDecls, new: newDecls)
                .sorted { $0.identifier < $1.identifier }
                .map(convertModification)
        } catch {
            assertionFailure("\(error)")
            return nil
        }
    }

    static func loadDeclarationSet(from url: URL?, moduleName: String) throws -> [DeclarationIdentifier: Set<DeclNode>] {
        #warning("TODO: sanitize `@_typeEraser(AnyView)` attribute on SwiftUI.View")

        if let url = url {
            return try collectDeclarations(from: DeclNode.parseList(SyntaxParser.parse(url)), in: moduleName)
        } else {
            return [:]
        }
    }

    static func compareDeclarationSets(old: [DeclarationIdentifier: Set<DeclNode>], new: [DeclarationIdentifier: Set<DeclNode>]) -> Set<Modification> {
        let oldIdentifiers = Set(old.keys)
        let newIdentifiers = Set(new.keys)

        var result: Set<Modification> = []

        result.formUnion(
            newIdentifiers
                .subtracting(oldIdentifiers)
                .map { Modification(identifier: $0, added: new[$0]!, removed: []) }
        )

        result.formUnion(
            oldIdentifiers
                .subtracting(newIdentifiers)
                .map { Modification(identifier: $0, added: [], removed: old[$0]!) }
        )

        result.formUnion(
            oldIdentifiers
                .intersection(newIdentifiers)
                .map { (id: $0, old: old[$0]!, new: new[$0]!) }
                .filter { $0.old != $0.new }
                .map { Modification(identifier: $0.id, added: $0.new.subtracting($0.old), removed: $0.old.subtracting($0.new)) }
        )

        return result
    }

    static func convertModification(_ modification: Modification) -> OCDifference {
        if modification.added.isEmpty && modification.removed.isEmpty {
            preconditionFailure()
        } else if modification.added.isEmpty {
            return OCDifference(
                type: .removal,
                name: modification.identifier.description,
                path: modification.identifier.type.first ?? "",
                lineNumber: 0
            )
        } else if modification.removed.isEmpty {
            return OCDifference(
                type: .addition,
                name: modification.identifier.description,
                path: modification.identifier.type.first ?? "",
                lineNumber: 0
            )
        } else if modification.added.count == 1 && modification.removed.count == 1 {
            return OCDifference.modificationDifference(
                withName: modification.identifier.description,
                path: modification.identifier.type.first ?? "",
                lineNumber: 0,
                modifications: DeclNodeComparator.modifications(
                    from: modification.removed.first!,
                    to: modification.added.first!
                )
            )
        } else {
            return OCDifference.modificationDifference(
                withName: modification.identifier.description,
                path: modification.identifier.type.first ?? "",
                lineNumber: 0,
                modifications: [
                    OCDModification(
                        type: .replacement,
                        previousValue: modification.removed.map(\.description).sorted().joined(separator: "\n"),
                        currentValue: modification.added.map(\.description).sorted().joined(separator: "\n")
                    )
                ]
            )
        }
    }

    struct Modification: Equatable, Hashable {
        let identifier: DeclarationIdentifier
        let added: Set<DeclNode>
        let removed: Set<DeclNode>
    }
}
