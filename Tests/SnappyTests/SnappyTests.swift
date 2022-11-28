import XCTest
import SystemPackage
@testable import Snappy

let testString = """
1 {
  1: "{file=Queues/QueuesCommand.swift,service=codes.vapor.application,line=122,function=startJobs(on:),source=Queues}"
  2 {
    1 {
      1: 1668371605
      2: 463043072
    }
    2: "[ERROR] Job run failed: RedisConnectionPoolError(baseError: RediStack.RedisConnectionPoolError.BaseError.timedOutWaitingForConnection)"
  }
}
"""

final class SnappyTests: XCTestCase {

    // MARK: - Basic Tests

    func testSimpleDataDeprecated() throws {
        let data = testString.data(using: .utf8)
        let compressedData = try XCTUnwrap(data?.compressedWithSnappy())

        let uncompressedData = try XCTUnwrap(compressedData.uncompressedWithSnappy())
        let uncompressedString = String(data: uncompressedData, encoding: .utf8)
        XCTAssertEqual(uncompressedString, testString)
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func testSimpleDataAsyncDeprecated() async throws {
        let data = testString.data(using: .utf8)
        let optionalCompressedData = await data?.compressedWithSnappy()
        let compressedData = try XCTUnwrap(optionalCompressedData)

        let optionalUncompressedData = await compressedData.uncompressedWithSnappy()
        let uncompressedData = try XCTUnwrap(optionalUncompressedData)
        let uncompressedString = String(data: uncompressedData, encoding: .utf8)
        XCTAssertEqual(uncompressedString, testString)
    }
}
