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

    func testSimpleDataAsyncDeprecated() async throws {
        let data = testString.data(using: .utf8)
        let optionalCompressedData = await data?.compressedWithSnappy()
        let compressedData = try XCTUnwrap(optionalCompressedData)

        let optionalUncompressedData = await compressedData.uncompressedWithSnappy()
        let uncompressedData = try XCTUnwrap(optionalUncompressedData)
        let uncompressedString = String(data: uncompressedData, encoding: .utf8)
        XCTAssertEqual(uncompressedString, testString)
    }

    func testSimpleDataResult() throws {
        let data = try XCTUnwrap(testString.data(using: .utf8))
        let compressionResult = data.compressedUsingSnappyWithResult()
        switch compressionResult {
        case .success(let compressedData):
            let uncompressionResult = compressedData.uncompressedUsingSnappyWithResult()
            switch uncompressionResult {
            case .success(let uncompressedData):
                XCTAssertEqual(String(data: uncompressedData, encoding: .utf8), testString)
            case .failure(let error):
                XCTFail("Error \"\(error)\" occurred in uncompression")
            }
        case .failure(let error):
            XCTFail("Error \"\(error)\" occurred in compression")
        }
    }

    func testSimpleDataThrowing() throws {
        let data = try XCTUnwrap(testString.data(using: .utf8))
        let compressedData = try data.compressedUsingSnappy()
        let uncompressedData = try compressedData.uncompressedUsingSnappy()
        XCTAssertEqual(String(data: uncompressedData, encoding: .utf8), testString)
    }

    func testSimpleDataAsync() async throws {
        let data = try XCTUnwrap(testString.data(using: .utf8))
        let compressedData = try await data.compressedUsingSnappy()
        let uncompressedData = try await compressedData.uncompressedUsingSnappy()
        XCTAssertEqual(String(data: uncompressedData, encoding: .utf8), testString)
    }

    // MARK: File I/O Tests

    func testIssacNewtonOpticksUncompression() async throws {
        let compressedFilePath = try XCTUnwrap(Bundle.module.path(forResource: "Isaac_Newton-Opticks", ofType: "rawsnappy"))
        let compressedFileURL = URL(fileURLWithPath: compressedFilePath)
        let compressedData = try Data(contentsOf: compressedFileURL)
        let uncompressedData = try await compressedData.uncompressedUsingSnappy()
        let uncompressedFileURL = try XCTUnwrap(Bundle.module.url(forResource: "Isaac_Newton-Opticks", withExtension: "txt"))
        XCTAssertEqual(uncompressedData, try Data(contentsOf: uncompressedFileURL))
    }

    func testBadData1ShouldFail() throws {
        try compressWithFailure(XCTUnwrap(Bundle.module.path(forResource: "baddata1", ofType: "snappy")), shouldFailWith: 5)
    }

    func testBadData2ShouldFail() throws {
        try compressWithFailure(XCTUnwrap(Bundle.module.path(forResource: "baddata2", ofType: "snappy")), shouldFailWith: 5)
    }

    func testBadData3ShouldFail() throws {
        try compressWithFailure(XCTUnwrap(Bundle.module.path(forResource: "baddata3", ofType: "snappy")), shouldFailWith: 5)
    }

    func testAliceInWonderland() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "alice29", ofType: "txt")))
    }

    func testAsYouLike() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "asyoulik", ofType: "txt")))
    }

    func testFireworks() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "fireworks", ofType: "jpeg")))
    }

    func testGeoProtoData() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "geo", ofType: "protodata")))
    }

    func testHtml() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "html", ofType: "")))
    }

    func testHtmlX4() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "html_x_4", ofType: "")))
    }

    func testKppkn() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "kppkn", ofType: "gtb")))
    }

    func testLcet10() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "lcet10", ofType: "txt")))
    }

    func testPaper100k() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "paper-100k", ofType: "pdf")))
    }

    func testPlarbn12() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "plrabn12", ofType: "txt")))
    }

    func testUrls() throws {
        try compressAndUncompress(XCTUnwrap(Bundle.module.path(forResource: "urls", ofType: "10K")))
    }

    // MARK: Helper

    func compressAndUncompress(_ resourcePath: String) throws {
        let uncompressedFileURL = URL(fileURLWithPath: resourcePath)
        let originalData = try Data(contentsOf: uncompressedFileURL)
        let compressedData = try originalData.compressedUsingSnappy()
        let uncompressedData = try compressedData.uncompressedUsingSnappy()
        XCTAssertEqual(originalData, uncompressedData)
    }

    func compressWithFailure(_ resourcePath: String, shouldFailWith errorNumber: CInt) throws {
        let fileURL = URL(fileURLWithPath: resourcePath)
        let badData = try Data(contentsOf: fileURL)
        XCTAssertThrowsError(try badData.uncompressedUsingSnappy()) { error in
            guard let error = error as? Errno else {
                XCTFail("Invalid error thrown")
                return
            }
            XCTAssertEqual(error, Errno(rawValue: errorNumber))
        }
    }
}
