import XCTest
@testable import JellyKit

final class JellyKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JellyKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
