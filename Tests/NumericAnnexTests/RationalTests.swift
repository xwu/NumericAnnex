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

  func testRationalRounding() {
    let a = 10 / 3 as Ratio
    XCTAssertEqual(a.rounded(), 3)
    XCTAssertEqual(a.rounded(.up), 4)
    XCTAssertEqual(a.rounded(.down), 3)
    XCTAssertEqual(a.rounded(.towardZero), 3)
    XCTAssertEqual(a.rounded(.awayFromZero), 4)
    XCTAssertEqual(a.rounded(.toNearestOrEven), 3)
    XCTAssertEqual(a.rounded(.toNearestOrAwayFromZero), 3)

    let b = -a
    XCTAssertEqual(b, -10 / 3)
    XCTAssertEqual(b.rounded(), -3)
    XCTAssertEqual(b.rounded(.up), -3)
    XCTAssertEqual(b.rounded(.down), -4)
    XCTAssertEqual(b.rounded(.towardZero), -3)
    XCTAssertEqual(b.rounded(.awayFromZero), -4)
    XCTAssertEqual(b.rounded(.toNearestOrEven), -3)
    XCTAssertEqual(b.rounded(.toNearestOrAwayFromZero), -3)

    let c = 5 / 2 as Ratio
    XCTAssertEqual(c.rounded(), 3)
    XCTAssertEqual(c.rounded(.up), 3)
    XCTAssertEqual(c.rounded(.down), 2)
    XCTAssertEqual(c.rounded(.towardZero), 2)
    XCTAssertEqual(c.rounded(.awayFromZero), 3)
    XCTAssertEqual(c.rounded(.toNearestOrEven), 2)
    XCTAssertEqual(c.rounded(.toNearestOrAwayFromZero), 3)

    let d = -c
    XCTAssertEqual(d, -5 / 2)
    XCTAssertEqual(d.rounded(), -3)
    XCTAssertEqual(d.rounded(.up), -2)
    XCTAssertEqual(d.rounded(.down), -3)
    XCTAssertEqual(d.rounded(.towardZero), -2)
    XCTAssertEqual(d.rounded(.awayFromZero), -3)
    XCTAssertEqual(d.rounded(.toNearestOrEven), -2)
    XCTAssertEqual(d.rounded(.toNearestOrAwayFromZero), -3)

    let e = 1 / 9 as Ratio
    XCTAssertEqual(e.rounded(), 0)
    XCTAssertEqual(e.rounded(.up), 1)
    XCTAssertEqual(e.rounded(.down), 0)
    XCTAssertEqual(e.rounded(.towardZero), 0)
    XCTAssertEqual(e.rounded(.awayFromZero), 1)
    XCTAssertEqual(e.rounded(.toNearestOrEven), 0)
    XCTAssertEqual(e.rounded(.toNearestOrAwayFromZero), 0)
  }

  static var allTests = [
    ("testRational", testRational),
    ("testRationalRounding", testRationalRounding),
  ]
}
