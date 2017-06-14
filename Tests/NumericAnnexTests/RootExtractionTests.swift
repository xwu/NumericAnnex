import XCTest
@testable import NumericAnnex

class RootExtractionTests : XCTestCase {
  func testSqrt() {
    XCTAssertEqual(Int.sqrt(0), 0)
    XCTAssertEqual(Int.sqrt(25), 5)
    XCTAssertEqual(Int.sqrt(27), 5)
    XCTAssertEqual(Int.sqrt(256), 16)
    XCTAssertEqual(Int.sqrt(512), 22)
    XCTAssertEqual(Int.sqrt(1 << 32) * Int.sqrt(1 << 32), 1 << 32)
    XCTAssertEqual(Int.sqrt(1 << 48) * Int.sqrt(1 << 48), 1 << 48)
    XCTAssertEqual(Int.sqrt(1 << 50) * Int.sqrt(1 << 50), 1 << 50)
    XCTAssertEqual(Int.sqrt(1 << 60) * Int.sqrt(1 << 60), 1 << 60)
    XCTAssertEqual(Int.sqrt(1 << 62) * Int.sqrt(1 << 62), 1 << 62)
    XCTAssertLessThanOrEqual(Int.sqrt(.max) * Int.sqrt(.max), Int.max)

    XCTAssertLessThanOrEqual(UInt.sqrt(.max) * UInt.sqrt(.max), UInt.max)
  }

  func testCbrt() {
    XCTAssertEqual(UInt.cbrt(0), 0)
    XCTAssertEqual(UInt.cbrt(25), 2)
    XCTAssertEqual(UInt.cbrt(27), 3)
    XCTAssertEqual(UInt.cbrt(256), 6)
    XCTAssertEqual(UInt.cbrt(512), 8)
    XCTAssertLessThanOrEqual(
      UInt.cbrt(.max) * UInt.cbrt(.max) * UInt.cbrt(.max),
      UInt.max
    )

    XCTAssertEqual(Int.cbrt(-27), -3)
    XCTAssertLessThanOrEqual(
      Int.cbrt(.max) * Int.cbrt(.max) * Int.cbrt(.max),
      Int.max
    )
  }

  static var allTests = [
    ("testSqrt", testSqrt),
    ("testCbrt", testCbrt),
  ]
}
