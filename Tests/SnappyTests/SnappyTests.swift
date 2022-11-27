import XCTest
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
    func testSimpleData() throws {
        let data = testString.data(using: .utf8)
        let compressedData = try XCTUnwrap(data?.compressedUsingSnappy())

        if #available(macOS 13.0, *) {
            let path = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appending(component: "compressedFile")

            try compressedData.write(to: path)
        } else {
            // Fallback on earlier versions
        }

        let uncompressedData = try XCTUnwrap(compressedData.uncompressedUsingSnappy())
        let uncompressedString = String(data: uncompressedData, encoding: .utf8)
        XCTAssertEqual(uncompressedString, testString)
    }
}
