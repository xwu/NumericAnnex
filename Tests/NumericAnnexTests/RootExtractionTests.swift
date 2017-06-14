import XCTest
@testable import NumericAnnex

class RootExtractionTests : XCTestCase {
  func testSqrt() {
    XCTAssertEqual(Int.sqrt(0), 0)
    XCTAssertEqual(Int.sqrt(25), 5)
    XCTAssertEqual(Int.sqrt(27), 5)
    XCTAssertEqual(Int.sqrt(256), 16)
    XCTAssertEqual(Int.sqrt(512), 22)
    XCTAssertEqual(Int.sqrt(1 << 32) * .sqrt(1 << 32), 1 << 32)
    XCTAssertEqual(Int.sqrt(1 << 48) * .sqrt(1 << 48), 1 << 48)
    XCTAssertEqual(Int.sqrt(1 << 50) * .sqrt(1 << 50), 1 << 50)
    XCTAssertEqual(Int.sqrt(1 << 60) * .sqrt(1 << 60), 1 << 60)
    XCTAssertEqual(Int.sqrt(1 << 62) * .sqrt(1 << 62), 1 << 62)

    XCTAssertLessThanOrEqual(Int.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(Int8.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(Int16.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(Int32.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(Int64.sqrt(.max) * .sqrt(.max), .max)

    XCTAssertLessThanOrEqual(UInt.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt8.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt16.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt32.sqrt(.max) * .sqrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt64.sqrt(.max) * .sqrt(.max), .max)
  }

  func testCbrt() {
    XCTAssertEqual(UInt.cbrt(0), 0)
    XCTAssertEqual(UInt.cbrt(25), 2)
    XCTAssertEqual(UInt.cbrt(27), 3)
    XCTAssertEqual(UInt.cbrt(256), 6)
    XCTAssertEqual(UInt.cbrt(512), 8)

    XCTAssertLessThanOrEqual(UInt.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt8.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt16.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt32.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(UInt64.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)

    XCTAssertEqual(Int.cbrt(-27), -3)

    XCTAssertLessThanOrEqual(Int.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(Int8.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(Int16.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(Int32.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
    XCTAssertLessThanOrEqual(Int64.cbrt(.max) * .cbrt(.max) * .cbrt(.max), .max)
  }

  static var allTests = [
    ("testSqrt", testSqrt),
    ("testCbrt", testCbrt),
  ]
}
