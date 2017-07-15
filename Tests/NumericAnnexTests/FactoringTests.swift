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

    XCTAssertTrue(Int8.gcdReportingOverflow(-128, -128).overflow == .overflow)

    // Test special values.
    XCTAssertEqual(UInt.gcd(0, 42), 42)
    XCTAssertEqual(UInt.gcd(42, 0), 42)
    XCTAssertEqual(UInt.gcd(0, 0), 0)
  }

  func testLCM() {
    XCTAssertEqual(UInt.lcm(4, 6), 12)
    XCTAssertEqual(UInt.lcm(6, 21), 42)

    XCTAssertEqual(Int.lcm(4, 6), 12)
    XCTAssertEqual(Int.lcm(6, 21), 42)

    XCTAssertEqual(Int8.lcmFullWidth(33, 48).high, 2)
    XCTAssertEqual(Int8.lcmFullWidth(33, 48).low, 16)
    XCTAssertEqual(Int8.lcmReportingOverflow(33, 48).partialValue, 16)
    XCTAssertTrue(Int8.lcmReportingOverflow(33, 48).overflow == .overflow)

    XCTAssertEqual(UInt8.lcmFullWidth(33, 48).high, 2)
    XCTAssertEqual(UInt8.lcmFullWidth(33, 48).low, 16)
    XCTAssertEqual(UInt8.lcmReportingOverflow(33, 48).partialValue, 16)
    XCTAssertTrue(UInt8.lcmReportingOverflow(33, 48).overflow == .overflow)

    // Test special values.
    XCTAssertEqual(UInt.lcm(0, 42), 0)
    XCTAssertEqual(UInt.lcm(42, 0), 0)
    XCTAssertEqual(UInt.lcm(0, 0), 0)

    XCTAssertEqual(Int8.lcmFullWidth(0, 42).high, 0)
    XCTAssertEqual(Int8.lcmFullWidth(0, 42).low, 0)
    XCTAssertEqual(Int8.lcmReportingOverflow(0, 42).partialValue, 0)
    XCTAssertTrue(Int8.lcmReportingOverflow(0, 42).overflow == .none)

    XCTAssertEqual(Int8.lcmFullWidth(42, 0).high, 0)
    XCTAssertEqual(Int8.lcmFullWidth(42, 0).low, 0)
    XCTAssertEqual(Int8.lcmReportingOverflow(42, 0).partialValue, 0)
    XCTAssertTrue(Int8.lcmReportingOverflow(42, 0).overflow == .none)

    XCTAssertEqual(Int8.lcmFullWidth(0, 0).high, 0)
    XCTAssertEqual(Int8.lcmFullWidth(0, 0).low, 0)
    XCTAssertEqual(Int8.lcmReportingOverflow(0, 0).partialValue, 0)
    XCTAssertTrue(Int8.lcmReportingOverflow(0, 0).overflow == .none)

    XCTAssertEqual(UInt8.lcmFullWidth(0, 42).high, 0)
    XCTAssertEqual(UInt8.lcmFullWidth(0, 42).low, 0)
    XCTAssertEqual(UInt8.lcmReportingOverflow(0, 42).partialValue, 0)
    XCTAssertTrue(UInt8.lcmReportingOverflow(0, 42).overflow == .none)

    XCTAssertEqual(UInt8.lcmFullWidth(42, 0).high, 0)
    XCTAssertEqual(UInt8.lcmFullWidth(42, 0).low, 0)
    XCTAssertEqual(UInt8.lcmReportingOverflow(42, 0).partialValue, 0)
    XCTAssertTrue(UInt8.lcmReportingOverflow(42, 0).overflow == .none)

    XCTAssertEqual(UInt8.lcmFullWidth(0, 0).high, 0)
    XCTAssertEqual(UInt8.lcmFullWidth(0, 0).low, 0)
    XCTAssertEqual(UInt8.lcmReportingOverflow(0, 0).partialValue, 0)
    XCTAssertTrue(UInt8.lcmReportingOverflow(0, 0).overflow == .none)
  }

  static var allTests = [
    ("testGCD", testGCD),
    ("testLCM", testLCM),
  ]
}
