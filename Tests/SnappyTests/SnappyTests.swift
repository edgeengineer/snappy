import Testing
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
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

@Suite("Snappy Tests")
struct SnappyTests {

    // MARK: - Basic Tests

    @Test("Simple data compression and decompression (deprecated API)")
    func testSimpleDataDeprecated() throws {
        let data = try #require(testString.data(using: .utf8))
        let compressedData = try #require(data.compressedWithSnappy())
        
        let uncompressedData = try #require(compressedData.uncompressedWithSnappy())
        let uncompressedString = String(data: uncompressedData, encoding: .utf8)
        #expect(uncompressedString == testString)
    }

    @Test("Simple data compression and decompression async (deprecated API)")
    func testSimpleDataAsyncDeprecated() async throws {
        let data = try #require(testString.data(using: .utf8))
        let compressedData = try #require(await data.compressedWithSnappy())
        
        let uncompressedData = try #require(await compressedData.uncompressedWithSnappy())
        let uncompressedString = String(data: uncompressedData, encoding: .utf8)
        #expect(uncompressedString == testString)
    }

    @Test("Simple data compression and decompression using Result")
    func testSimpleDataResult() throws {
        let data = try #require(testString.data(using: .utf8))
        let compressionResult = data.compressedUsingSnappyWithResult()
        switch compressionResult {
        case .success(let compressedData):
            let uncompressionResult = compressedData.uncompressedUsingSnappyWithResult()
            switch uncompressionResult {
            case .success(let uncompressedData):
                #expect(String(data: uncompressedData, encoding: .utf8) == testString)
            case .failure(let error):
                Issue.record("Error \"\(error)\" occurred in uncompression")
            }
        case .failure(let error):
            Issue.record("Error \"\(error)\" occurred in compression")
        }
    }

    @Test("Simple data compression and decompression (throwing API)")
    func testSimpleDataThrowing() throws {
        let data = try #require(testString.data(using: .utf8))
        let compressedData = try data.compressedUsingSnappy()
        let uncompressedData = try compressedData.uncompressedUsingSnappy()
        #expect(String(data: uncompressedData, encoding: .utf8) == testString)
    }

    @Test("Simple data compression and decompression async")
    func testSimpleDataAsync() async throws {
        let data = try #require(testString.data(using: .utf8))
        let compressedData = try await data.compressedUsingSnappy()
        let uncompressedData = try await compressedData.uncompressedUsingSnappy()
        #expect(String(data: uncompressedData, encoding: .utf8) == testString)
    }

    // MARK: File I/O Tests

    @Test("Isaac Newton Opticks uncompression")
    func testIssacNewtonOpticksUncompression() async throws {
        let compressedFilePath = try #require(Bundle.module.path(forResource: "Isaac_Newton-Opticks", ofType: "rawsnappy"))
        let compressedFileURL = URL(fileURLWithPath: compressedFilePath)
        let compressedData = try Data(contentsOf: compressedFileURL)
        let uncompressedData = try await compressedData.uncompressedUsingSnappy()
        let uncompressedFileURL = try #require(Bundle.module.url(forResource: "Isaac_Newton-Opticks", withExtension: "txt"))
        let expectedData = try Data(contentsOf: uncompressedFileURL)
        #expect(uncompressedData == expectedData)
    }

    @Test("Bad data 1 should fail")
    func testBadData1ShouldFail() throws {
        try compressWithFailure(#require(Bundle.module.path(forResource: "baddata1", ofType: "snappy")), shouldFailWith: 5)
    }

    @Test("Bad data 2 should fail")
    func testBadData2ShouldFail() throws {
        try compressWithFailure(#require(Bundle.module.path(forResource: "baddata2", ofType: "snappy")), shouldFailWith: 5)
    }

    @Test("Bad data 3 should fail")
    func testBadData3ShouldFail() throws {
        try compressWithFailure(#require(Bundle.module.path(forResource: "baddata3", ofType: "snappy")), shouldFailWith: 5)
    }

    @Test("Alice in Wonderland compression and decompression")
    func testAliceInWonderland() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "alice29", ofType: "txt")))
    }

    @Test("As You Like It compression and decompression")
    func testAsYouLike() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "asyoulik", ofType: "txt")))
    }

    @Test("Fireworks JPEG compression and decompression")
    func testFireworks() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "fireworks", ofType: "jpeg")))
    }

    @Test("Geo proto data compression and decompression")
    func testGeoProtoData() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "geo", ofType: "protodata")))
    }

    @Test("HTML compression and decompression")
    func testHtml() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "html", ofType: "")))
    }

    @Test("HTML x4 compression and decompression")
    func testHtmlX4() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "html_x_4", ofType: "")))
    }

    @Test("Kppkn GTB compression and decompression")
    func testKppkn() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "kppkn", ofType: "gtb")))
    }

    @Test("Lcet10 compression and decompression")
    func testLcet10() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "lcet10", ofType: "txt")))
    }

    @Test("Paper 100k PDF compression and decompression")
    func testPaper100k() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "paper-100k", ofType: "pdf")))
    }

    @Test("Plrabn12 compression and decompression")
    func testPlarbn12() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "plrabn12", ofType: "txt")))
    }

    @Test("URLs compression and decompression")
    func testUrls() throws {
        try compressAndUncompress(#require(Bundle.module.path(forResource: "urls", ofType: "10K")))
    }

    // MARK: Helper

    func compressAndUncompress(_ resourcePath: String) throws {
        let uncompressedFileURL = URL(fileURLWithPath: resourcePath)
        let originalData = try Data(contentsOf: uncompressedFileURL)
        let compressedData = try originalData.compressedUsingSnappy()
        let uncompressedData = try compressedData.uncompressedUsingSnappy()
        #expect(originalData == uncompressedData)
    }

    func compressWithFailure(_ resourcePath: String, shouldFailWith errorNumber: CInt) throws {
        let fileURL = URL(fileURLWithPath: resourcePath)
        let badData = try Data(contentsOf: fileURL)
        #expect(throws: Errno(rawValue: errorNumber)) {
            try badData.uncompressedUsingSnappy()
        }
    }
}