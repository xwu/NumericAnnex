import XCTest
@testable import NumericAnnex

class FactoringTests : XCTestCase {
  func testGCD() {
    XCTAssertEqual(UInt.gcd(18, 84), 6)
    XCTAssertEqual(UInt.gcd(24, 60), 12)
    XCTAssertEqual(UInt.gcd(42, 56), 14)

    XCTAssertEqual(Int.gcd(18, 84), 6)
    XCTAssertEqual(Int.gcd(24, 60), 12)
    XCTAssertEqual(Int.gcd(42, 56), 14)

    // Test special values.
    XCTAssertEqual(UInt.gcd(0, 42), 42)
    XCTAssertEqual(UInt.gcd(42, 0), 42)
    XCTAssertEqual(UInt.gcd(0, 0), 0)

    XCTAssertTrue(Int8.gcdReportingOverflow(-128, -128).overflow == .overflow)
  }

  func testLCM() {
    XCTAssertEqual(UInt.lcm(4, 6), 12)
    XCTAssertEqual(UInt.lcm(6, 21), 42)

    XCTAssertEqual(Int.lcm(4, 6), 12)
    XCTAssertEqual(Int.lcm(6, 21), 42)

    // Test special values.
    XCTAssertEqual(UInt.lcm(0, 42), 0)
    XCTAssertEqual(UInt.lcm(42, 0), 0)
    XCTAssertEqual(UInt.lcm(0, 0), 0)
  }

  static var allTests = [
    ("testGCD", testGCD),
    ("testLCM", testLCM),
  ]
}
