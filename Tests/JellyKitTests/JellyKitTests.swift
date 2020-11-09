import XCTest
@testable import JellyKit

final class JellyKitTests: XCTestCase {
    func testServerLocator() {
        let expect = expectation(description: "Server Response")
        let locator = try! ServerLocator()
        locator.locateServer() { success in
            print(success)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 120.0)
    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
