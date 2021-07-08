//
//  TestUtilities.swift
//  RepositoryBrowserTests
//
//  Created by Anders Lassen on 07/07/2021.
//

import Foundation
import XCTest
import Combine

/// Utilities used to test @Published properties.
///
///- Note: code adapted from: https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/
///
extension XCTestCase {
    
    func wait<T: Publisher>(
        _ publisher: T,
        completionExpectedFulfillmentCount: Int = 0,
        valueExpectedFulfillmentCount: Int = 1,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        expectation.expectedFulfillmentCount = completionExpectedFulfillmentCount + valueExpectedFulfillmentCount
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
