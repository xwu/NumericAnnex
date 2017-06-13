import XCTest
@testable import NumericAnnex

class ExponentiationTests : XCTestCase {
  func testIntPow() {
    for i in -21...21 {
      for j in -7...7 {
        if i == 0 && j < 0 {
          // In this case, Int.pow(i, j) causes a division-by-zero error.
          // Likewise, Double.pow(Double(i), Double(j)) also causes the same
          // error.
          continue
        }
        let actual = Int.pow(i, j)
        let expected = Int(Double.pow(Double(i), Double(j)))
        XCTAssertEqual(actual, expected)
      }
    }
  }

  func testUIntPow() {
    for i in (0 as UInt)...21 {
      for j in (0 as UInt)...7 {
        let actual = UInt.pow(i, j)
        let expected = UInt(Double.pow(Double(i), Double(j)))
        XCTAssertEqual(actual, expected)
      }
    }
  }

  static var allTests = [
    ("testIntPow", testIntPow),
    ("testUIntPow", testUIntPow),
  ]
}
