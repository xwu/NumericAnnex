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

    let z = Big<Int8>(Int8.max)
    let a = Int(Int8.max)
    XCTAssertEqual((z * z).description, (a * a).description)
    XCTAssertEqual((z * z * z).description, (a * a * a).description)
  }

  func testBigIntBitwiseNot() {
    for i in Int8.min...Int8.max {
      let big = Big<Int8>(i)
      let small = i
      XCTAssertEqual((~big).description, (~small).description)
    }
  }

  func testBigIntFactorial() {
    func factorial(_ n: BigInt) -> BigInt { return (1...n).reduce(1, *) }

    XCTAssertEqual(factorial(1).description, "1")
    XCTAssertEqual(factorial(2).description, "2")
    XCTAssertEqual(factorial(3).description, "6")
    XCTAssertEqual(factorial(4).description, "24")
    XCTAssertEqual(factorial(5).description, "120")
    XCTAssertEqual(factorial(6).description, "720")
    XCTAssertEqual(factorial(7).description, "5040")
    XCTAssertEqual(factorial(8).description, "40320")
    XCTAssertEqual(factorial(9).description, "362880")
    XCTAssertEqual(factorial(10).description, "3628800")

    XCTAssertEqual(
      factorial(50).description,
      "30414093201713378043612608166064768844377641568960512000000000000"
    )

    XCTAssertEqual(
      factorial(100).description,
      "9332621544394415268169923885626670049071596826438162146859296389521759" +
      "9993229915608941463976156518286253697920827223758251185210916864000000" +
      "000000000000000000"
    )
  }

  static var allTests = [
    ("testBigInt", testBigInt),
    ("testBigIntBitwiseNot", testBigIntBitwiseNot),
    ("testBigIntFactorial", testBigIntFactorial),
  ]
}
