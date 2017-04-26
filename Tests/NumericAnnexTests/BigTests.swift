import XCTest
@testable import NumericAnnex

class BigTests: XCTestCase {
  func testBigInt() {
    let x: Big<Int> = 3
    XCTAssertEqual(x + x, 6)
    XCTAssertEqual(x - x, 0)
  }

  static var allTests = [
    ("testBigInt", testBigInt),
  ]
}
