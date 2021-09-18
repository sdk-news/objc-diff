import XCTest
import SwiftSyntax
import SwiftSyntaxAnalysis

final class SwiftReaderTests: XCTestCase {
    func testExample() throws {
        let parsedSyntax = try ParsedSytax(source: """
            class Foo {}
            """)

        let node = ClassDeclNode(syntax: parsedSyntax.classDeclSyntax[0])
        XCTAssertEqual(node.name, "Foo")
    }
}
