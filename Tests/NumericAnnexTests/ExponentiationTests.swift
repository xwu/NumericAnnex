import XCTest
@testable import NumericAnnex

class ExponentiationTests : XCTestCase {
  func testIntPow() {
    for i in -21...21 {
      for j in -7...7 {
        if i == 0 && j < 0 {
          // In this case, i ** j causes a division-by-zero error.
          // Likewise, Double(i) ** Double(j) also causes the same error.
          continue
        }
        let actual = i ** j
        let expected = Int(Double(i) ** Double(j))
        XCTAssertEqual(actual, expected)
      }
    }
  }

  func testUIntPow() {
    for i in (0 as UInt)...21 {
      for j in (0 as UInt)...7 {
        let actual = i ** j
        let expected = UInt(Double(i) ** Double(j))
        XCTAssertEqual(actual, expected)
      }
    }
  }

  func testConcreteIntegerTypePow() {
    XCTAssertEqual((2 as Int) ** 3, 8 as Int)
    XCTAssertEqual((2 as Int8) ** 3, 8 as Int8)
    XCTAssertEqual((2 as Int16) ** 3, 8 as Int16)
    XCTAssertEqual((2 as Int32) ** 3, 8 as Int32)
    XCTAssertEqual((2 as Int64) ** 3, 8 as Int64)

    do { var x = 2 as Int; x **= 3; XCTAssertEqual(x, 8 as Int) }
    do { var x = 2 as Int8; x **= 3; XCTAssertEqual(x, 8 as Int8) }
    do { var x = 2 as Int16; x **= 3; XCTAssertEqual(x, 8 as Int16) }
    do { var x = 2 as Int32; x **= 3; XCTAssertEqual(x, 8 as Int32) }
    do { var x = 2 as Int64; x **= 3; XCTAssertEqual(x, 8 as Int64) }

    XCTAssertEqual((2 as UInt) ** 3, 8 as UInt)
    XCTAssertEqual((2 as UInt8) ** 3, 8 as UInt8)
    XCTAssertEqual((2 as UInt16) ** 3, 8 as UInt16)
    XCTAssertEqual((2 as UInt32) ** 3, 8 as UInt32)
    XCTAssertEqual((2 as UInt64) ** 3, 8 as UInt64)

    do { var x = 2 as UInt; x **= 3; XCTAssertEqual(x, 8 as UInt) }
    do { var x = 2 as UInt8; x **= 3; XCTAssertEqual(x, 8 as UInt8) }
    do { var x = 2 as UInt16; x **= 3; XCTAssertEqual(x, 8 as UInt16) }
    do { var x = 2 as UInt32; x **= 3; XCTAssertEqual(x, 8 as UInt32) }
    do { var x = 2 as UInt64; x **= 3; XCTAssertEqual(x, 8 as UInt64) }
  }

  func testGenericIntegerTypePow() {
    func _testPow<
      T : BinaryInteger
    >(_: T.Type = T.self, lhs: T, rhs: T, expected: T) {
      XCTAssertEqual(lhs ** rhs, expected)
      do { var x = lhs; x **= rhs; XCTAssertEqual(x, expected) }
    }
    _testPow(lhs: 2 as Int, rhs: 3, expected: 8)
    _testPow(lhs: 2 as UInt, rhs: 3, expected: 8)
  }

  static var allTests = [
    ("testIntPow", testIntPow),
    ("testUIntPow", testUIntPow),
    ("testConcreteIntegerTypePow", testConcreteIntegerTypePow),
    ("testGenericIntegerTypePow", testGenericIntegerTypePow),
  ]
}
