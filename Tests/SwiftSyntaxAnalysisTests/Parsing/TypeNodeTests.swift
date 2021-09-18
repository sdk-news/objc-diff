import XCTest
import SwiftSyntax
import SwiftSyntaxParser
import SwiftSyntaxAnalysis

final class TypeNodeTests: XCTestCase {
    func testSimple() throws {
        let syntax = try SyntaxParser.parse(source: "var x: Foo").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .simple(node) = node {
            XCTAssertEqual(node.name, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testOptional() throws {
        let syntax = try SyntaxParser.parse(source: "var x: Foo?").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .optional(node) = node {
            XCTAssertEqual(node.type.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testMember() throws {
        let syntax = try SyntaxParser.parse(source: "var x: Foo.Bar").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .member(node) = node {
            XCTAssertEqual(node.parent.description, "Foo")
            XCTAssertEqual(node.name, "Bar")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testTuple() throws {
        let syntax = try SyntaxParser.parse(source: "var x: (Foo, Bar)").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .tuple(node) = node {
            XCTAssertEqual(node.elements[0].type.description, "Foo")
            XCTAssertEqual(node.elements[1].type.description, "Bar")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testFunction() throws {
        let syntax = try SyntaxParser.parse(source: "var x: () -> Foo").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .function(node) = node {
            XCTAssertEqual(node.return.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testArray() throws {
        let syntax = try SyntaxParser.parse(source: "var x: [Foo]").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .array(node) = node {
            XCTAssertEqual(node.element.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testDictionary() throws {
        let syntax = try SyntaxParser.parse(source: "var x: [Foo: Bar]").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .dictionary(node) = node {
            XCTAssertEqual(node.key.description, "Foo")
            XCTAssertEqual(node.value.description, "Bar")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testSome() throws {
        let syntax = try SyntaxParser.parse(source: "var x: some Foo").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .some(node) = node {
            XCTAssertEqual(node.type.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testImplicitlyUnwrappedOptional() throws {
        let syntax = try SyntaxParser.parse(source: "var x: Foo!").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .implicitlyUnwrappedOptional(node) = node {
            XCTAssertEqual(node.type.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testComposition() throws {
        let syntax = try SyntaxParser.parse(source: "var x: Foo & Bar").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .composition(node) = node {
            XCTAssertEqual(Set(node.types.map(\.description)), ["Foo", "Bar"])
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testAttributed() throws {
        let syntax = try SyntaxParser.parse(source: "var x: @escaping Foo").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .attributed(node) = node {
            XCTAssertEqual(node.type.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testMetatype() throws {
        let syntax = try SyntaxParser.parse(source: "var x: Foo.Type").findAll(of: TypeSyntax.self).first!
        let node = TypeNode(syntax: syntax)

        if case let .metatype(node) = node {
            XCTAssertEqual(node.type.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }
}
