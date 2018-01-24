import XCTest
@testable import NumericAnnex

class RationalTests : XCTestCase {
  func testRational() {
    let a = 6 / 4 as Rational<Int>
    XCTAssertEqual(a.magnitude, a)
    XCTAssertEqual(abs(a), a)
    XCTAssertEqual(a.description, "3/2")
    XCTAssertEqual(a, 3 / 2 as Rational<Int>)
    XCTAssertTrue(a.isFinite)
    XCTAssertFalse(a.isProper)
    XCTAssertTrue(a.reciprocal().isProper)

    let b = 5 / 3 as Rational<Int>
    XCTAssertEqual(b.magnitude, b)
    XCTAssertEqual(abs(b), b)
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
    XCTAssertEqual(abs(c), a)
    XCTAssertEqual(c.description, "-3/2")
    XCTAssertEqual(c, -3 / 2 as Rational<Int>)
    XCTAssertTrue(c.isFinite)
    XCTAssertFalse(c.isProper)
    XCTAssertTrue(c.reciprocal().isProper)

    let d = -5 / 3 as Rational<Int>
    XCTAssertEqual(d.magnitude, b)
    XCTAssertEqual(abs(d), b)
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
    XCTAssertEqual(r, abs(c))
    r = d
    r.negate()
    XCTAssertEqual(r, b)
    XCTAssertEqual(r, d.magnitude)
    XCTAssertEqual(r, abs(d))

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

#if !swift(>=4.1)
    XCTAssertTrue(Ratio(numerator: 2, denominator: 0).isInfinite)
    XCTAssertFalse(Ratio(numerator: 2, denominator: 0).isCanonical)
#endif

    let ni = -Ratio.infinity
    XCTAssertEqual(ni.description, "-inf")
    XCTAssertTrue(ni.isCanonical)

#if !swift(>=4.1)
    XCTAssertTrue(Ratio(numerator: -2, denominator: 0).isInfinite)
    XCTAssertFalse(Ratio(numerator: -2, denominator: 0).isCanonical)
#endif

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
#if !swift(>=4.1)
    XCTAssertEqual(pi + 0, .infinity)
    XCTAssertEqual(ni + 0, -.infinity)
#endif
    XCTAssertEqual(pi + 42, .infinity)
    XCTAssertEqual(pi - 42, .infinity)
    XCTAssertEqual(ni + 42, -.infinity)
    XCTAssertEqual(ni - 42, -.infinity)
#if !swift(>=4.1)
    XCTAssertEqual(0 + pi, .infinity)
    XCTAssertEqual(0 + ni, -.infinity)
#endif
    XCTAssertEqual(42 + pi, .infinity)
    XCTAssertEqual(42 - pi, -.infinity)
    XCTAssertEqual(42 + ni, -.infinity)
    XCTAssertEqual(42 - ni, .infinity)

    XCTAssertTrue((pi + ni).isNaN)
    XCTAssertTrue((ni + pi).isNaN)
    XCTAssertTrue((pi - pi).isNaN)
    XCTAssertTrue((-pi + pi).isNaN)

#if !swift(>=4.1)
    XCTAssertTrue((0 / 0 as Ratio).isNaN)
    XCTAssert((0 / 0 as Ratio) != .nan) // NaN compares unequal to everything.
    XCTAssertTrue((42 / 0 as Ratio).isInfinite)
    XCTAssertTrue((-42 / 0 as Ratio).isInfinite)
    XCTAssert(42 / 0 as Ratio == .infinity)
    XCTAssert(-42 / 0 as Ratio == -.infinity)
    XCTAssertEqual((42 / 0 as Ratio).description, "inf")
    XCTAssertEqual((-42 / 0 as Ratio).description, "-inf")
#endif

    XCTAssertEqual(pi * pi, .infinity)
    XCTAssertEqual(pi * ni, -.infinity)
    XCTAssertEqual(ni * pi, -.infinity)
    XCTAssertEqual(ni * ni, .infinity)

#if !swift(>=4.1)
    XCTAssertTrue((pi * 0).isNaN)
    XCTAssertTrue((ni * 0).isNaN)
    XCTAssertTrue((0 * pi).isNaN)
    XCTAssertTrue((0 * ni).isNaN)
#endif
    XCTAssertTrue((pn * pi).isNaN)
    XCTAssertTrue((pi * pn).isNaN)
    XCTAssertTrue((pn * ni).isNaN)
    XCTAssertTrue((ni * pn).isNaN)

    XCTAssertTrue(pn.canonical.isNaN)
  }

  func testRationalConversion() {
    var d: Double, r: Ratio, r8: Rational<Int8>, r64: Rational<Int64>

    r = Ratio(42)
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)
    XCTAssertEqual(Int(exactly: r)!, 42)

    r = Ratio(exactly: 42)!
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)
    XCTAssertEqual(Int(exactly: r)!, 42)

    r = Ratio(42 as Double)
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)
    XCTAssertEqual(Int(exactly: r)!, 42)

    r = Ratio(exactly: 42 as Double)!
    XCTAssertEqual(r, 42)
    XCTAssertEqual(Int(r), 42)
    XCTAssertEqual(Int(exactly: r)!, 42)

    r = Ratio(UInt8.max)
    XCTAssertEqual(UInt8(r), .max)
    XCTAssertEqual(UInt8(exactly: r)!, .max)

    r = Ratio(exactly: UInt8.max)!
    XCTAssertEqual(UInt8(r), .max)
    XCTAssertEqual(UInt8(exactly: r)!, .max)

    r = Ratio(Int16.min)
    XCTAssertEqual(Int16(r), .min)
    XCTAssertNil(UInt16(exactly: r))

    r = Ratio(exactly: Int16.min)!
    XCTAssertEqual(Int16(r), .min)
    XCTAssertNil(UInt16(exactly: r))

    r8 = Rational(exactly: Int8.max)!
    XCTAssertEqual(Int8(r8), .max)
    XCTAssertEqual(Int8(exactly: r8)!, .max)

    r8 = Rational(exactly: Double(Int8.max))!
    XCTAssertEqual(Int8(r8), .max)
    XCTAssertEqual(Int8(exactly: r8)!, .max)

    XCTAssertNil(Rational<Int8>(exactly: Int16.max))
    XCTAssertNil(Rational<Int8>(exactly: Double(Int8.max) + 1))
    XCTAssertNil(Rational<Int8>(exactly: Int8.min))
    XCTAssertNil(Rational<Int8>(exactly: Double(Int8.min)))
    XCTAssertNil(Rational<Int8>(exactly: 1 / Double(Int8.min)))

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

    let a = Rational<Int8>(0.125)
    XCTAssertEqual(Float(a), 0.125)
    XCTAssertEqual(Double(a), 0.125)

    let aa = Rational<Int8>(8)
    XCTAssertEqual(Float(aa), 8)
    XCTAssertEqual(Double(aa), 8)

    let b = Rational<Int16>(0.0625)
    XCTAssertEqual(Float(b), 0.0625)
    XCTAssertEqual(Double(b), 0.0625)

    let bb = Rational<Int16>(16)
    XCTAssertEqual(Float(bb), 16)
    XCTAssertEqual(Double(bb), 16)

    let c = Rational<Int32>(0.03125)
    XCTAssertEqual(Float(c), 0.03125)
    XCTAssertEqual(Double(c), 0.03125)

    let cc = Rational<Int32>(32)
    XCTAssertEqual(Float(cc), 32)
    XCTAssertEqual(Double(cc), 32)

    r64 = Rational<Int64>(0.015625)
    XCTAssertEqual(Float(r64), 0.015625)
    XCTAssertEqual(Double(r64), 0.015625)

    r64 = Rational<Int64>(64)
    XCTAssertEqual(Float(r64), 64)
    XCTAssertEqual(Double(r64), 64)
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
    XCTAssert(j >= 42)
    XCTAssert(!(j < l))
    XCTAssert(!(j < 42))
    XCTAssert(!(j <= 42))
    XCTAssert(j != m)
    XCTAssert(j > m)
    XCTAssert(!(j < m))
    XCTAssert(l != j)
    XCTAssert(l < j)
    XCTAssert(l < 42)
    XCTAssert(l <= 42)
    XCTAssert(!(l > j))
    XCTAssert(!(l > 42))
    XCTAssert(!(l >= 42))
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

    XCTAssertEqual(round(a), 3)
    XCTAssertEqual(ceil(a), 4)
    XCTAssertEqual(floor(a), 3)
    XCTAssertEqual(trunc(a), 3)

    let b = -a
    XCTAssertEqual(b, -10 / 3)
    XCTAssertEqual(b.rounded(), -3)
    XCTAssertEqual(b.rounded(.up), -3)
    XCTAssertEqual(b.rounded(.down), -4)
    XCTAssertEqual(b.rounded(.towardZero), -3)
    XCTAssertEqual(b.rounded(.awayFromZero), -4)
    XCTAssertEqual(b.rounded(.toNearestOrEven), -3)
    XCTAssertEqual(b.rounded(.toNearestOrAwayFromZero), -3)

    XCTAssertEqual(round(b), -3)
    XCTAssertEqual(ceil(b), -3)
    XCTAssertEqual(floor(b), -4)
    XCTAssertEqual(trunc(b), -3)

    let c = 5 / 2 as Ratio
    XCTAssertEqual(c.rounded(), 3)
    XCTAssertEqual(c.rounded(.up), 3)
    XCTAssertEqual(c.rounded(.down), 2)
    XCTAssertEqual(c.rounded(.towardZero), 2)
    XCTAssertEqual(c.rounded(.awayFromZero), 3)
    XCTAssertEqual(c.rounded(.toNearestOrEven), 2)
    XCTAssertEqual(c.rounded(.toNearestOrAwayFromZero), 3)

    XCTAssertEqual(round(c), 3)
    XCTAssertEqual(ceil(c), 3)
    XCTAssertEqual(floor(c), 2)
    XCTAssertEqual(trunc(c), 2)

    let d = -c
    XCTAssertEqual(d, -5 / 2)
    XCTAssertEqual(d.rounded(), -3)
    XCTAssertEqual(d.rounded(.up), -2)
    XCTAssertEqual(d.rounded(.down), -3)
    XCTAssertEqual(d.rounded(.towardZero), -2)
    XCTAssertEqual(d.rounded(.awayFromZero), -3)
    XCTAssertEqual(d.rounded(.toNearestOrEven), -2)
    XCTAssertEqual(d.rounded(.toNearestOrAwayFromZero), -3)

    XCTAssertEqual(round(d), -3)
    XCTAssertEqual(ceil(d), -2)
    XCTAssertEqual(floor(d), -3)
    XCTAssertEqual(trunc(d), -2)

    let e = 1 / 9 as Ratio
    XCTAssertEqual(e.rounded(), 0)
    XCTAssertEqual(e.rounded(.up), 1)
    XCTAssertEqual(e.rounded(.down), 0)
    XCTAssertEqual(e.rounded(.towardZero), 0)
    XCTAssertEqual(e.rounded(.awayFromZero), 1)
    XCTAssertEqual(e.rounded(.toNearestOrEven), 0)
    XCTAssertEqual(e.rounded(.toNearestOrAwayFromZero), 0)

    XCTAssertEqual(round(e), 0)
    XCTAssertEqual(ceil(e), 1)
    XCTAssertEqual(floor(e), 0)
    XCTAssertEqual(trunc(e), 0)

    let f = Ratio.infinity
    XCTAssertEqual(f.rounded(), f)

    let g = -Ratio.infinity
    XCTAssertEqual(g.rounded(), g)

    let h = Ratio.nan
    XCTAssertTrue(h.rounded().isNaN)
  }

  func testRationalStride() {
    let a = zip(stride(from: 1/3 as Ratio, to: 3, by: 1/3), 1...8)
    for i in a {
      XCTAssertEqual(i.0 * 3, Ratio(i.1))
    }

    let b = zip(stride(from: 1/3 as Ratio, through: 3, by: 1/3), 1...9)
    for i in b {
      XCTAssertEqual(i.0 * 3, Ratio(i.1))
    }
    XCTAssertEqual(Int(b.map { $0.0 }.last!), 3)

    let c = zip(stride(from: 3 as Ratio, to: 1/3, by: -1/3), (2...9).reversed())
    for i in c {
      XCTAssertEqual(i.0 * 3, Ratio(i.1))
    }

    let d =
      zip(stride(from: 3 as Ratio, through: 1/3, by: -1/3), (1...9).reversed())
    for i in d {
      XCTAssertEqual(i.0 * 3, Ratio(i.1))
    }
    XCTAssertEqual(Int(d.map { $0.0 }.last! * 3), 1)

    let e = zip(stride(from: -3 as Ratio, to: -1/3, by: 1/3), -9...(-1))
    for i in e {
      XCTAssertEqual(i.0 * 3, Ratio(i.1))
    }

    let f = zip(stride(from: -3 as Ratio, through: -1/3, by: 1/3), -9...(-1))
    for i in f {
      XCTAssertEqual(i.0 * 3, Ratio(i.1))
    }
    XCTAssertEqual(Int(f.map { $0.0 }.last! * 3), -1)

    let values: [Ratio] = [6/4, 5/3, 4/6, 3/5, -3/5, -4/6, -5/3, -6/4]
    for i in values {
      for j in values {
        XCTAssertEqual(i.advanced(by: i.distance(to: j)), j)
      }
    }
  }

  static var allTests = [
    ("testRational", testRational),
    ("testRationalConversion", testRationalConversion),
    ("testRationalComparison", testRationalComparison),
    ("testRationalRounding", testRationalRounding),
    ("testRationalStride", testRationalStride),
  ]
}
