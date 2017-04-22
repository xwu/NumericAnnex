import XCTest
@testable import NumericAnnex

class RationalTests: XCTestCase {
  func testRational() {
    let a = 6 / 4 as Rational<Int>
    XCTAssertEqual(a.description, "3/2")
    XCTAssertEqual(a, 3 / 2 as Rational<Int>)

    let b = 5 / 3 as Rational<Int>
    XCTAssertEqual(b.description, "5/3")
    XCTAssertLessThan(a, b)

    XCTAssertEqual(a + b, 19 / 6 as Ratio)
    XCTAssertEqual(b + a, 19 / 6 as Ratio)
    XCTAssertEqual(a - b, -1 / 6 as Ratio)
    XCTAssertEqual(b - a, 1 / 6 as Ratio)
    XCTAssertEqual(a * b, 5 / 2 as Ratio)
    XCTAssertEqual(b * a, 5 / 2 as Ratio)
    XCTAssertEqual(a / b, 9 / 10 as Ratio)
    XCTAssertEqual(b / a, 10 / 9 as Ratio)

    XCTAssertEqual((10 / 9 as Ratio).mixed.whole, 1)
    XCTAssertEqual((10 / 9 as Ratio).mixed.fractional, 1 / 9)

    // Test special values.
    let pn = Ratio.nan
    let pi = Ratio.infinity
    let ni = -Ratio.infinity

    XCTAssertTrue((pn + pn).isNaN)
    XCTAssertTrue((pn - pn).isNaN)
    XCTAssertTrue((pn * pn).isNaN)
    XCTAssertTrue((pn / pn).isNaN)

    XCTAssertEqual(pi + pi, .infinity)
    XCTAssertEqual(ni + ni, -.infinity)
    XCTAssertEqual(pi + 0, .infinity)
    XCTAssertEqual(ni + 0, -.infinity)
    XCTAssertEqual(pi + 42, .infinity)
    XCTAssertEqual(pi - 42, .infinity)
    XCTAssertEqual(ni + 42, -.infinity)
    XCTAssertEqual(ni - 42, -.infinity)

    XCTAssertTrue((pi + ni).isNaN)
    XCTAssertTrue((ni + pi).isNaN)
    XCTAssertTrue((pi - pi).isNaN)
    XCTAssertTrue((-pi + pi).isNaN)

    XCTAssertTrue((0 / 0 as Ratio).isNaN)
    XCTAssert((0 / 0 as Ratio) != .nan) // NaN compares unequal to everything.
    XCTAssertTrue((42 / 0 as Ratio).isInfinite)
    XCTAssertTrue((-42 / 0 as Ratio).isInfinite)
    XCTAssert(42 / 0 as Ratio == .infinity)
    XCTAssert(-42 / 0 as Ratio == -.infinity)
    XCTAssertEqual((42 / 0 as Ratio).description, "inf")
    XCTAssertEqual((-42 / 0 as Ratio).description, "-inf")

    XCTAssertEqual(pi * pi, .infinity)
    XCTAssertEqual(pi * ni, -.infinity)
    XCTAssertEqual(ni * pi, -.infinity)
    XCTAssertEqual(ni * ni, .infinity)

    XCTAssertTrue((pi * 0).isNaN)
    XCTAssertTrue((ni * 0).isNaN)
    XCTAssertTrue((0 * pi).isNaN)
    XCTAssertTrue((0 * ni).isNaN)
    XCTAssertTrue((pn * pi).isNaN)
    XCTAssertTrue((pi * pn).isNaN)
    XCTAssertTrue((pn * ni).isNaN)
    XCTAssertTrue((ni * pn).isNaN)
  }

  static var allTests = [
    ("testRational", testRational),
  ]
}
