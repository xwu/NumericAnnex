import XCTest
@testable import NumericAnnex

class RationalTests : XCTestCase {
  func testRational() {
    let a = 6 / 4 as Rational<Int>
    XCTAssertEqual(a.magnitude, a)
    XCTAssertEqual(a.description, "3/2")
    XCTAssertEqual(a, 3 / 2 as Rational<Int>)
    XCTAssertTrue(a.isFinite)
    XCTAssertFalse(a.isProper)
    XCTAssertTrue(a.reciprocal().isProper)

    let b = 5 / 3 as Rational<Int>
    XCTAssertEqual(b.magnitude, b)
    XCTAssertEqual(b.description, "5/3")
    XCTAssertTrue(b.isFinite)
    XCTAssertFalse(b.isProper)
    XCTAssertTrue(b.reciprocal().isProper)

    XCTAssertLessThan(a, b)
    XCTAssertEqual(a + b, 19 / 6 as Ratio)
    XCTAssertEqual(b + a, 19 / 6 as Ratio)
    XCTAssertEqual(a - b, -1 / 6 as Ratio)
    XCTAssertEqual(b - a, 1 / 6 as Ratio)
    XCTAssertEqual(a * b, 5 / 2 as Ratio)
    XCTAssertEqual(b * a, 5 / 2 as Ratio)
    XCTAssertEqual(a / b, 9 / 10 as Ratio)
    XCTAssertEqual(b / a, 10 / 9 as Ratio)

    var r = a
    r += b
    XCTAssertEqual(r, a + b)
    r = a
    r -= b
    XCTAssertEqual(r, a - b)
    r = b
    r -= a
    XCTAssertEqual(r, b - a)
    r = a
    r *= b
    XCTAssertEqual(r, a * b)
    r = a
    r /= b
    XCTAssertEqual(r, a / b)
    r = b
    r /= a
    XCTAssertEqual(r, b / a)

    let c = -6 / 4 as Rational<Int>
    XCTAssertEqual(c.magnitude, a)
    XCTAssertEqual(c.description, "-3/2")
    XCTAssertEqual(c, -3 / 2 as Rational<Int>)
    XCTAssertTrue(c.isFinite)
    XCTAssertFalse(c.isProper)
    XCTAssertTrue(c.reciprocal().isProper)

    let d = -5 / 3 as Rational<Int>
    XCTAssertEqual(d.magnitude, b)
    XCTAssertEqual(d.description, "-5/3")
    XCTAssertTrue(d.isFinite)
    XCTAssertFalse(d.isProper)
    XCTAssertTrue(d.reciprocal().isProper)

    XCTAssertEqual(c + a, 0)
    XCTAssertEqual(d + b, 0)
    XCTAssertEqual(c + c, -3)
    XCTAssertEqual(d + d, -10 / 3)

    r = c
    r.negate()
    XCTAssertEqual(r, a)
    XCTAssertEqual(r, c.magnitude)
    r = d
    r.negate()
    XCTAssertEqual(r, b)
    XCTAssertEqual(r, d.magnitude)

    let e = 42 as Rational<Int>
    XCTAssertEqual(e.description, "42")

    XCTAssertEqual((10 / 9 as Ratio).mixed.whole, 1)
    XCTAssertEqual((10 / 9 as Ratio).mixed.fractional, 1 / 9)

    // Test special values.
    let pn = Ratio.nan
    XCTAssertEqual(pn.description, "nan")
    XCTAssertTrue(pn.isCanonical)

    let pi = Ratio.infinity
    XCTAssertEqual(pi.description, "inf")
    XCTAssertTrue(pi.isCanonical)

    XCTAssertTrue(Ratio(numerator: 2, denominator: 0).isInfinite)
    XCTAssertFalse(Ratio(numerator: 2, denominator: 0).isCanonical)

    let ni = -Ratio.infinity
    XCTAssertEqual(ni.description, "-inf")
    XCTAssertTrue(ni.isCanonical)

    XCTAssertTrue(Ratio(numerator: -2, denominator: 0).isInfinite)
    XCTAssertFalse(Ratio(numerator: -2, denominator: 0).isCanonical)

    let zero = 0 as Ratio
    XCTAssertEqual(zero.description, "0")
    XCTAssertTrue(zero.isCanonical)
    XCTAssertTrue(zero.isZero)

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

    XCTAssertTrue(pn.canonical.isNaN)
  }

  func testRationalConversion() {
    var d: Double, r: Ratio, r64: Rational<Int64>

    r = Ratio(42)
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)

    r = Ratio(exactly: 42)!
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)

    r = Ratio(42 as Double)
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)

    r = Ratio(exactly: 42 as Double)!
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)

    r = Ratio(UInt8.max)
    XCTAssertEqual(UInt8(r), .max)

    r = Ratio(exactly: UInt8.max)!
    XCTAssertEqual(UInt8(r), .max)

    r = Ratio(Int16.min)
    XCTAssertEqual(Int16(r), .min)
    XCTAssertNil(UInt16(exactly: r))

    r = Ratio(exactly: Int16.min)!
    XCTAssertEqual(Int16(r), .min)
    XCTAssertNil(UInt16(exactly: r))

    XCTAssertNil(Ratio(exactly: Int.min))

    r64 = Rational(Double.pi)
    XCTAssertEqual(Double(r64), .pi)
    XCTAssertTrue(r64.isCanonical)

    r64 = Rational(exactly: Double.pi)!
    XCTAssertEqual(Double(r64), .pi)
    XCTAssertTrue(r64.isCanonical)

    XCTAssertNil(Rational<Int32>(exactly: Double.pi))

    r64 = Rational(Double.e)
    XCTAssertEqual(Double(r64), .e)
    XCTAssertTrue(r64.isCanonical)

    r64 = Rational(Double.phi)
    XCTAssertEqual(Double(r64), .phi)
    XCTAssertTrue(r64.isCanonical)

    r = Ratio(Float.pi)
    XCTAssertEqual(Float(r), .pi)
    XCTAssertTrue(r.isCanonical)

    r = Ratio(exactly: Float.pi)!
    XCTAssertEqual(Float(r), .pi)
    XCTAssertTrue(r.isCanonical)

    r = Ratio(Float.e)
    XCTAssertEqual(Float(r), .e)
    XCTAssertTrue(r.isCanonical)

    r = Ratio(Float.phi)
    XCTAssertEqual(Float(r), .phi)
    XCTAssertTrue(r.isCanonical)

    d = 0
    XCTAssertEqual(Ratio(d), 0)
    XCTAssertEqual(Ratio(exactly: d)!, 0)
    XCTAssertEqual(Double(Ratio(d)), 0)

    d = -0.0
    XCTAssertEqual(Ratio(d), 0)
    XCTAssertEqual(Ratio(exactly: d)!, 0)
    XCTAssertEqual(Double(Ratio(d)), 0)

    d = 0.ulp
    XCTAssertTrue(d.isSubnormal)
    XCTAssertEqual(d.significand, 1)
    XCTAssertEqual(d.exponent, -1074)
    XCTAssertNil(Ratio(exactly: d))

    d = .infinity
    XCTAssertEqual(Ratio(d), .infinity)
    XCTAssertEqual(Ratio(exactly: d)!, .infinity)
    XCTAssertEqual(Double(Ratio(d)), .infinity)

    d = -.infinity
    XCTAssertEqual(Ratio(d), -.infinity)
    XCTAssertEqual(Ratio(exactly: d)!, -.infinity)
    XCTAssertEqual(Double(Ratio(d)), -.infinity)

    d = .nan
    XCTAssertTrue(Ratio(d).isNaN)
    XCTAssertTrue(Ratio(exactly: d)!.isNaN)
    XCTAssertTrue(Double(Ratio(d)).isNaN)
  }

  func testRationalComparison() {
    let a = 1 / 2 as Ratio
    let b = 1 / 4 as Ratio
    XCTAssert(a != b)
    XCTAssert(a == a)
    XCTAssert(a <= a)
    XCTAssert(a >= a)
    XCTAssert(!(a < a))
    XCTAssert(b == b)
    XCTAssert(b <= b)
    XCTAssert(b >= b)
    XCTAssert(a > b)
    XCTAssert(a >= b)
    XCTAssert(b < a)
    XCTAssert(b <= a)

    let c = -1 / 2 as Ratio
    let d = -1 / 4 as Ratio
    XCTAssert(c != d)
    XCTAssert(c == c)
    XCTAssert(c <= c)
    XCTAssert(c >= c)
    XCTAssert(!(c < c))
    XCTAssert(d == d)
    XCTAssert(d <= d)
    XCTAssert(d >= d)
    XCTAssert(c < d)
    XCTAssert(c <= d)
    XCTAssert(d > c)
    XCTAssert(d >= c)

    XCTAssert(c < a)
    XCTAssert(!(a < c))
    XCTAssert(c <= a)
    XCTAssert(!(a <= c))

    let e = Ratio(numerator: 0, denominator: 1)
    let f = Ratio(numerator: 0, denominator: 2)
    let g = Ratio(numerator: 0, denominator: -1)
    let h = Ratio(numerator: 0, denominator: -2)
    let i = Ratio(numerator: 0, denominator: 0)
    XCTAssert(e.sign == .plus)
    XCTAssert(e == f)
    XCTAssert(f.sign == .plus)
    XCTAssert(e == g)
    XCTAssert(g.sign == .plus)
    XCTAssert(e == h)
    XCTAssert(h.sign == .plus)
    XCTAssert(e != i)
    XCTAssert(i != i)

    let j = Ratio.infinity
    let k = Ratio(numerator: 2, denominator: 0)
    let l = -Ratio.infinity
    let m = Ratio(numerator: -2, denominator: 0)
    let n = Ratio.nan
    XCTAssert(j == k)
    XCTAssert(j >= k)
    XCTAssert(!(j < k))
    XCTAssert(j != l)
    XCTAssert(j > l)
    XCTAssert(j > 42)
    XCTAssert(!(j < l))
    XCTAssert(!(j < 42))
    XCTAssert(j != m)
    XCTAssert(j > m)
    XCTAssert(!(j < m))
    XCTAssert(l != j)
    XCTAssert(l < j)
    XCTAssert(l < 42)
    XCTAssert(!(l > j))
    XCTAssert(!(l > 42))
    XCTAssert(l != k)
    XCTAssert(l < k)
    XCTAssert(!(l > k))
    XCTAssert(l == m)
    XCTAssert(l >= m)
    XCTAssert(!(l < m))
    XCTAssert(j != n)
    XCTAssert(!(j < n))
    XCTAssert(!(j <= n))
    XCTAssert(!(j > n))
    XCTAssert(!(j >= n))
    XCTAssert(l != n)
    XCTAssert(!(l < n))
    XCTAssert(!(l <= n))
    XCTAssert(!(l > n))
    XCTAssert(!(l >= n))
    XCTAssert(n != n)
    XCTAssert(!(n < n))
    XCTAssert(!(n <= n))
    XCTAssert(!(n > n))
    XCTAssert(!(n >= n))
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

    let f = Ratio.infinity
    XCTAssertEqual(f.rounded(), f)

    let g = -Ratio.infinity
    XCTAssertEqual(g.rounded(), g)

    let h = Ratio.nan
    XCTAssertTrue(h.rounded().isNaN)
  }

  static var allTests = [
    ("testRational", testRational),
    ("testRationalConversion", testRationalConversion),
    ("testRationalComparison", testRationalComparison),
    ("testRationalRounding", testRationalRounding),
  ]
}
