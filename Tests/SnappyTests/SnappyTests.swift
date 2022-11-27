import XCTest
@testable import Snappy

final class SnappyTests: XCTestCase {
    func testExample() throws {
        let data = """
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
.data(using: .utf8)
        let d = data?.compressedUsingSnappy()
        let compressedData = try XCTUnwrap(d)
        print(compressedData)
        let uncompressedData = try XCTUnwrap(compressedData.decompressedUsingSnappy())
        XCTAssertEqual(String(data: uncompressedData, encoding: .utf8), String(data: try XCTUnwrap(data), encoding: .utf8))
    }
}
