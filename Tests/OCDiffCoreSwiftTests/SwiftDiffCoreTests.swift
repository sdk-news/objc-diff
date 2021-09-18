import XCTest
import SwiftSyntax
import SwiftSyntaxParser
import SwiftSyntaxAnalysis
@testable import OCDiffCoreSwift

extension DeclNode {
    public static func parseList(_ url: URL) throws -> Set<DeclNode> {
        return try parseList(SyntaxParser.parse(url))
    }
}

final class SwiftDiffCoreTests: XCTestCase {
    func testExample() throws {
        let diff = OCDSwiftInterfaceComparator.compareModule(
            "SwiftUI",
            oldInterfaceURL: URL(fileURLWithPath: "/Applications/Xcode-12.5.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64.swiftinterface"),
            newInterfaceURL: URL(fileURLWithPath: "/Applications/Xcode-13-beta-5.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64.swiftinterface")
        )

        print(diff)
    }
}
