import SwiftSyntax
import SwiftSyntaxParser

struct ParsedSytax {
    var classDeclSyntax: [ClassDeclSyntax] = []
    var enumDeclSyntax: [EnumDeclSyntax] = []
    var extensionDeclSyntax: [ExtensionDeclSyntax] = []
    var structDeclSyntax: [StructDeclSyntax] = []
    var protocolDeclSyntax: [ProtocolDeclSyntax] = []

    init(source: String) throws {
        let syntax = try SyntaxParser.parse(source: source)
        let visitor = Visitor()
        visitor.walk(syntax)
        self = visitor.parsedSyntax
    }

    private init() {}

    private class Visitor: SyntaxVisitor {
        var parsedSyntax = ParsedSytax()

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            parsedSyntax.classDeclSyntax.append(node)
            return .visitChildren
        }

        override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
            parsedSyntax.enumDeclSyntax.append(node)
            return .visitChildren
        }

        override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
            parsedSyntax.extensionDeclSyntax.append(node)
            return .visitChildren
        }

        override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
            parsedSyntax.structDeclSyntax.append(node)
            return .visitChildren
        }

        override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
            parsedSyntax.protocolDeclSyntax.append(node)
            return .visitChildren
        }
    }
}
