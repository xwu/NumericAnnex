import XCTest
@testable import NumericAnnex

class BigTests: XCTestCase {
  func testBigInt() {
    let x = 3 as BigInt
    XCTAssertEqual(x + x, 6)
    XCTAssertEqual(x - x, 0)

    let y = BigInt(Int.max)
    XCTAssertEqual(y.description, Int.max.description)
    XCTAssertEqual((-y).description, "-" + y.description)
    XCTAssertEqual((y + y).description, "18446744073709551614")
    XCTAssertEqual((y + y - y - y - y).description, (-y).description)
    XCTAssertEqual((-y + -y).description, "-18446744073709551614")
    XCTAssertEqual((-y - y).description, "-18446744073709551614")
  }

  static var allTests = [
    ("testBigInt", testBigInt),
  ]
}
