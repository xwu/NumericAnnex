import XCTest
@testable import NumericAnnex

class NumericAnnexTests: XCTestCase {
  func testComplexAddition() {
    let foo: Complex<Double> = 1.0 + 2.0 * .i
    let bar: Complex<Double> = 2 + 4 * .i
    XCTAssertEqual(foo + bar, 3 + 6 * .i)

    /*
    let baz: Complex<Float> = 2 + 4 * .i
    let boo = 3 + (6 as Float).i
    */
  }

  func testComplexDivision() {
    let a = 3 + 2 * Complex<Double>.i
    let b = 4 - 3 * Complex<Double>.i
    let c = a / b
    XCTAssertEqual(c.real, 6/25)
    XCTAssertEqual(c.imaginary, 17/25)
  }

  func testComplexSquareRoot() {
    let a: Complex<Double> = -4
    XCTAssertEqual(Complex.sqrt(a), 2 * .i)
  }

  func testComplexExponentiation() {
    let i: Complex<Double> = .i
    let actual = i.power(of: i)
    let expected = Double.exp(-Double.pi / 2)
    XCTAssertEqual(actual.real, expected)
    XCTAssertEqual(actual.imaginary, 0)
  }

  static var allTests = [
    ("testComplexAddition", testComplexAddition),
    ("testComplexDivision", testComplexDivision),
    ("testComplexSquareRoot", testComplexSquareRoot),
    ("testComplexExponentiation", testComplexExponentiation),
  ]
}
