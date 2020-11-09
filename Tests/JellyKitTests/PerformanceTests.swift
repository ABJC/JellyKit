//
//  PerformanceTests.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import XCTest
@testable import JellyKit

class PerformanceTests: XCTestCase {
    private var api: API!
    
    override func setUpWithError() throws {
        let exp = expectation(description: "Authorize")
        api = API("192.168.178.10", 8096, nil, nil)
        var err: Error? = nil
        api.authorize("jellyfin", "") { response in
            switch response {
            case .success(_ ): break
            case .failure(let error): err = error
            }
            exp.fulfill()
        }
        if err != nil {
            throw err!
        }
        waitForExpectations(timeout: 30.0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testItemFetch() {
        measure() {
            let expect = expectation(description: "run")
            api.getItems { result in
                switch result {
                case .success(_): break
                case .failure(let error): XCTFail(error.localizedDescription)
                }
                expect.fulfill()
            }
            waitForExpectations(timeout: 10.0)
        }
    }
}
