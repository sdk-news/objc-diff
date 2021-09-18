import XCTest
import SwiftSyntax
import SwiftSyntaxParser
import SwiftSyntaxAnalysis

final class DeclNodeTests: XCTestCase {
    func testAssociatedtype() throws {
        let syntax = try SyntaxParser.parse(source: "associatedtype Foo")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .associatedtype(node) = nodes.first {
            XCTAssertEqual(node.name, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testClass() throws {
        let syntax = try SyntaxParser.parse(source: "class Foo {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .class(node) = nodes.first {
            XCTAssertEqual(node.name, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testDeinitializer() throws {
        let syntax = try SyntaxParser.parse(source: "deinit {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .deinitializer = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testEnum() throws {
        let syntax = try SyntaxParser.parse(source: "enum Foo {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .enum(node) = nodes.first {
            XCTAssertEqual(node.name, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testEnumCase() throws {
        let syntax = try SyntaxParser.parse(source: "case foo")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .enumCase(node) = nodes.first {
            XCTAssertEqual(node.name, "foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testEnumCases() throws {
        let syntax = try SyntaxParser.parse(source: "case foo, bar")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 2)

        let names: [String] = nodes.compactMap { node in
            if case let .enumCase(node) = node {
                return node.name
            } else {
                XCTFail("Unexpected parsed node type")
                return nil
            }
        }

        XCTAssertEqual(Set(names), ["foo", "bar"])
    }

    func testExtension() throws {
        let syntax = try SyntaxParser.parse(source: "extension Foo {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .extension(node) = nodes.first {
            XCTAssertEqual(node.type.description, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testFunction() throws {
        let syntax = try SyntaxParser.parse(source: "func foo()")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .function(node) = nodes.first {
            XCTAssertEqual(node.name, "foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testIfConfig() throws {
        let syntax = try SyntaxParser.parse(source: "#if TEST\n#endif")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .ifConfig = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testImport() throws {
        let syntax = try SyntaxParser.parse(source: "import Foo")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .import = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testInitializer() throws {
        let syntax = try SyntaxParser.parse(source: "init()")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .initializer = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testOperator() throws {
        let syntax = try SyntaxParser.parse(source: "operator <=>")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .operator = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testPoundError() throws {
        let syntax = try SyntaxParser.parse(source: "#error(\"foo\")")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .poundError = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testPoundWarning() throws {
        let syntax = try SyntaxParser.parse(source: "#warning(\"foo\")")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .poundWarning = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testPrecedenceGroup() throws {
        let syntax = try SyntaxParser.parse(source: "precedencegroup Foo {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .precedenceGroup = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testProtocol() throws {
        let syntax = try SyntaxParser.parse(source: "protocol Foo {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .protocol(node) = nodes.first {
            XCTAssertEqual(node.name, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testStruct() throws {
        let syntax = try SyntaxParser.parse(source: "struct Foo {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .struct(node) = nodes.first {
            XCTAssertEqual(node.name, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testSubscript() throws {
        let syntax = try SyntaxParser.parse(source: "subscript(index: Int) -> Int {}")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case .subscript = nodes.first {
            // ...
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testTypealias() throws {
        let syntax = try SyntaxParser.parse(source: "typealias Foo = Bar")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .typealias(node) = nodes.first {
            XCTAssertEqual(node.name, "Foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testVariabe() throws {
        let syntax = try SyntaxParser.parse(source: "var foo: Int")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 1)

        if case let .variable(node) = nodes.first, case let .identifier(pattern) = node.pattern {
            XCTAssertEqual(pattern.name, "foo")
        } else {
            XCTFail("Unexpected parsed node type")
        }
    }

    func testVariabes() throws {
        let syntax = try SyntaxParser.parse(source: "var foo: Int, bar: Int")
        let nodes = DeclNode.parseList(syntax)
        XCTAssertEqual(nodes.count, 2)

        let names: [String] = nodes.compactMap { node in
            if case let .variable(node) = node, case let .identifier(pattern) = node.pattern {
                return pattern.name
            } else {
                XCTFail("Unexpected parsed node type")
                return nil
            }
        }

        XCTAssertEqual(Set(names), ["foo", "bar"])
    }
}
