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

  static var allTests = [
    ("testIntPow", testIntPow),
    ("testUIntPow", testUIntPow),
  ]
}
