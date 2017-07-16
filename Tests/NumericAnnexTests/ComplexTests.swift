import XCTest
@testable import NumericAnnex

class ComplexTests : XCTestCase {
  let pzpz = Complex(real: +0.0, imaginary: +0.0)
  let pznz = Complex(real: +0.0, imaginary: -0.0)
  let nzpz = Complex(real: -0.0, imaginary: +0.0)
  let nznz = Complex(real: -0.0, imaginary: -0.0)

  let pipi = Complex(real: Double.infinity, imaginary: .infinity)
  let pini = Complex(real: Double.infinity, imaginary: -.infinity)
  let nipi = Complex(real: -Double.infinity, imaginary: .infinity)
  let nini = Complex(real: -Double.infinity, imaginary: -.infinity)

  let pipz = Complex(real: .infinity, imaginary: +0.0)
  let nipz = Complex(real: -.infinity, imaginary: +0.0)
  let pinz = Complex(real: .infinity, imaginary: -0.0)
  let ninz = Complex(real: -.infinity, imaginary: -0.0)

  let pzpi = Complex(real: +0.0, imaginary: .infinity)

  let pxpi = Complex(real: +2.0, imaginary: .infinity)
  let pxni = Complex(real: +2.0, imaginary: -.infinity)
  let pipy = Complex(real: .infinity, imaginary: +2.0)
  let nipy = Complex(real: -.infinity, imaginary: +2.0)

  let pzpn = Complex(real: +0.0, imaginary: .nan)
  let nzpn = Complex(real: -0.0, imaginary: .nan)
  let pnpz = Complex(real: .nan, imaginary: +0.0)
  let pnnz = Complex(real: .nan, imaginary: -0.0)

  let pxpn = Complex(real: +2.0, imaginary: .nan)
  let nxpn = Complex(real: -2.0, imaginary: .nan)
  let pnpy = Complex(real: .nan, imaginary: +2.0)
  let pnny = Complex(real: .nan, imaginary: -2.0)

  let pipn = Complex(real: Double.infinity, imaginary: .nan)
  let nipn = Complex(real: -Double.infinity, imaginary: .nan)
  let pnpi = Complex(real: Double.nan, imaginary: .infinity)
  let pnni = Complex(real: Double.nan, imaginary: -.infinity)

  let pnpn = Complex(real: Double.nan, imaginary: .nan)

  func testComplexInitialization() {
    let foo = Complex128(42 as Double)
    let bar = 42 as Complex128
    XCTAssertEqual(foo, bar)

    var c128 = Complex128(42 as Float)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as Int8)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as Int16)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as Int32)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as Int64)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as Int)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as UInt8)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as UInt16)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as UInt32)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as UInt64)
    XCTAssertEqual(c128, bar)
    c128 = Complex128(42 as UInt)
    XCTAssertEqual(c128, bar)
    // `Double(exactly:)` is unimplemented in the standard library.
    /*
    c128 = Complex128(exactly: 42 as Int8)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as Int16)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as Int32)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as Int64)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as Int)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as UInt8)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as UInt16)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as UInt32)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as UInt64)!
    XCTAssertEqual(c128, bar)
    c128 = Complex128(exactly: 42 as UInt)!
    XCTAssertEqual(c128, bar)
    */

    let baz = Complex64(42 as Float)
    let boo = 42 as Complex64
    XCTAssertEqual(baz, boo)

    var c64 = Complex64(42 as Double)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as Int8)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as Int16)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as Int32)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as Int64)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as Int)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as UInt8)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as UInt16)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as UInt32)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as UInt64)
    XCTAssertEqual(c64, boo)
    c64 = Complex64(42 as UInt)
    XCTAssertEqual(c64, boo)
#if false
    // `Float(exactly:)` is unimplemented in the standard library.
    c64 = Complex64(exactly: 42 as Int8)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as Int16)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as Int32)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as Int64)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as Int)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as UInt8)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as UInt16)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as UInt32)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as UInt64)!
    XCTAssertEqual(c64, boo)
    c64 = Complex64(exactly: 42 as UInt)!
    XCTAssertEqual(c64, boo)
    XCTAssertNil(Complex64(exactly: Int32.max))
#endif
  }

  func testComplexConstants() {
    XCTAssertEqual(Complex128.pi, Complex(Double.pi))
    XCTAssertEqual(Complex128.e, Complex(Double.e))
    XCTAssertEqual(Complex128.phi, Complex(Double.phi))

    XCTAssertEqual(Complex64.pi, Complex(Float.pi))
    XCTAssertEqual(Complex64.e, Complex(Float.e))
    XCTAssertEqual(Complex64.phi, Complex(Float.phi))
  }

  func testComplexBooleanProperties() {
    var c128: Complex128 = 42 + 42 * .i
    XCTAssertTrue(c128.isFinite)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = 42 + Complex(imaginary: .infinity)
    XCTAssertFalse(c128.isFinite)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = 42 + Complex(Double.infinity) * .i
    XCTAssertFalse(c128.isFinite)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(imaginary: .infinity) + 42 * .i
    XCTAssertFalse(c128.isFinite)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(Double.infinity) + 42 * .i
    XCTAssertFalse(c128.isFinite)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(real: .nan, imaginary: 42)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(real: .nan, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(real: 42, imaginary: .nan)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(real: .infinity, imaginary: .nan)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(real: .signalingNaN, imaginary: 42)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.isSignalingNaN)

    c128 = Complex(real: .signalingNaN, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = Complex(real: 42, imaginary: .signalingNaN)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.isSignalingNaN)
    
    c128 = Complex(real: .infinity, imaginary: .signalingNaN)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    XCTAssertFalse(c128.isSignalingNaN)

    c128 = 2 + Complex(Double.nan) * .i // NaN + iNaN
    XCTAssertFalse(c128.isFinite)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertFalse(c128.real.isFinite)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = 2 + Complex(imaginary: .nan) // 2 + iNaN
    XCTAssertFalse(c128.isFinite)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isFinite)
    XCTAssertFalse(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)
  }

  func testComplexDescription() {
    let a: Complex128 = 42 + 42 * .i
    XCTAssertEqual(a.description, "42.0 + 42.0i")
    let b: Complex128 = -42 + 42 * .i
    XCTAssertEqual(b.description, "-42.0 + 42.0i")
    let c: Complex128 = 42 - 42 * .i
    XCTAssertEqual(c.description, "42.0 - 42.0i")
    let d: Complex128 = -42 - 42 * .i
    XCTAssertEqual(d.description, "-42.0 - 42.0i")
    let e: Complex128 = Complex(real: .infinity, imaginary: .infinity)
    XCTAssertEqual(e.description, "inf + infi")
    let f: Complex128 = Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertEqual(f.description, "-inf + infi")
    let g: Complex128 = Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertEqual(g.description, "inf - infi")
    let h: Complex128 = Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertEqual(h.description, "-inf - infi")
    let j: Complex128 = Complex(real: 0.0, imaginary: 0.0)
    XCTAssertEqual(j.description, "0.0 + 0.0i")
    let k: Complex128 = Complex(real: -0.0, imaginary: 0.0)
    XCTAssertEqual(k.description, "-0.0 + 0.0i")
    let l: Complex128 = Complex(real: 0.0, imaginary: -0.0)
    XCTAssertEqual(l.description, "0.0 - 0.0i")
    let m: Complex128 = Complex(real: -0.0, imaginary: -0.0)
    XCTAssertEqual(m.description, "-0.0 - 0.0i")
    let n: Complex128 = Complex(real: .nan, imaginary: .nan)
    XCTAssertEqual(n.description, "nan + nani")
    let o = -n
    XCTAssertEqual(o.description, "-nan - nani")
  }

  func testComplexNegation() {
    let a: Complex128 = 2 + 4 * .i
    let b = -a
    let c = -b
    XCTAssertEqual(a, c)

    var c128 = a
    c128.negate()
    c128.negate()
    XCTAssertEqual(a, c128)

    let d: Complex128 = Complex(real: .infinity, imaginary: .infinity)
    let e = -d
    let f = -e
    XCTAssertEqual(d, f)

    c128 = d
    c128.negate()
    c128.negate()
    XCTAssertEqual(d, c128)

    let g: Complex128 = 0 + 0 * .i
    XCTAssertTrue(g.isZero)
    let h = -g
    let i = -h
    XCTAssertEqual(g, i)

    c128 = g
    c128.negate()
    XCTAssertTrue(g == c128)
    c128.negate()
    XCTAssertEqual(g, c128)

    let j: Complex128 = Complex(real: .nan, imaginary: .nan)
    let k = -j
    let l = -k
    XCTAssertTrue(l.real.isNaN)
    XCTAssertTrue(l.imaginary.isNaN)
    XCTAssertTrue(l.isNaN)

    c128 = j
    c128.negate()
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)
    c128.negate()
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)
  }

  func testComplexAddition() {
    let foo: Complex128 = 1.0 + 2.0 * .i
    let bar: Complex128 = 2 + 4 * .i
    XCTAssertEqual(foo + bar, 3 + 6 * .i)

    var c128 = foo
    c128 += bar
    XCTAssertEqual(c128, foo + bar)

    let baz: Complex64 = 1 + 2 * .i
    let boo: Complex64 = 2.0 + 4.0 * .i
    XCTAssertEqual((foo + bar).real, Double((baz + boo).real))
    XCTAssertEqual((foo + bar).imaginary, Double((baz + boo).imaginary))

    var c64 = baz
    c64 += boo
    XCTAssertEqual(c64, baz + boo)

    let moo: Complex64 = .pi + .e * .i
    XCTAssertEqual(moo.real, .pi)
    XCTAssertEqual(moo.imaginary, .e)

    c64 = .pi
    c64 += .e * .i
    XCTAssertEqual(c64, moo)

    c64 = .e
    c64 *= .i
    c64 += .pi
    XCTAssertEqual(c64, moo)
  }

  func testComplexDivision() {
    let a = 3 + 2 * Complex128.i
    let b = 4 - 3 * Complex128.i
    let c = a / b
    XCTAssertEqual(c.real, 6/25)
    XCTAssertEqual(c.imaginary, 17/25)

    var c128 = a
    c128 /= b
    XCTAssertEqual(c128, c)
  }

  func testComplexInfinity() {
    let a = Complex128(real: .infinity) * .i
    XCTAssertTrue(a.real.isNaN)
    XCTAssertTrue(a.imaginary.isInfinite)
    XCTAssertTrue(a.isInfinite)
    XCTAssertFalse(a.isNaN)

    let b = 1 * Complex128(real: .infinity, imaginary: .infinity)
    XCTAssertTrue(b.isInfinite)
    XCTAssertFalse(b.isNaN)

    let c = Complex128.exp(Complex(real: .infinity, imaginary: .nan))
    XCTAssertTrue(c.isInfinite)
    XCTAssertFalse(c.isNaN)

    let d = Complex128.exp(Complex(real: -.infinity, imaginary: .nan))
    XCTAssertTrue(d.isZero)
    XCTAssertFalse(d.isNaN)

    var c128: Complex128

    // Test multiplication with infinity.
    c128 = Complex(real: .infinity, imaginary: .infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: 0) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -0.0) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .nan) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: 0) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -0.0) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .nan) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: .infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: .infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: .infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: -.infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: -.infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: -.infinity) * 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .infinity, imaginary: 0)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .infinity, imaginary: -0.0)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .infinity, imaginary: .nan)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -.infinity, imaginary: 0)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -.infinity, imaginary: -0.0)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -.infinity, imaginary: .nan)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: 0, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -0.0, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .nan, imaginary: .infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: 0, imaginary: -.infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: -0.0, imaginary: -.infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 * Complex(real: .nan, imaginary: -.infinity)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: 0)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -0.0)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .nan)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: 0)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -0.0)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .nan)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: .infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: .infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: .infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: -.infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: -.infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: -.infinity)
    c128 *= c128
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: .infinity, imaginary: 0)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: 0)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: 0, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: 0, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: -.infinity, imaginary: 0)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: 0)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: 0, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: 0, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: 0)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: 0)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: 0, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: 0, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: .infinity, imaginary: .nan)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: .nan)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: .nan, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: .nan, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: -.infinity, imaginary: .nan)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: .nan)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: .nan, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: .nan, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: .nan)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: .nan)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: .nan, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: .nan, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: .infinity, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: 0)
    c128 *= Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: 0, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    c128 = Complex(real: .nan, imaginary: .nan)
    c128 *= Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertFalse(c128.isInfinite)
    XCTAssertTrue(c128.isNaN)
    XCTAssertTrue(c128.real.isNaN)
    XCTAssertTrue(c128.imaginary.isNaN)

    let greatest = Complex128(
      real: .greatestFiniteMagnitude,
      imaginary: .greatestFiniteMagnitude
    )

    c128 = greatest * Complex(real: 2, imaginary: .nan)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 2, imaginary: .nan) * greatest
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = greatest * Complex(real: .nan, imaginary: 2)
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: 2) * greatest
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
    
    // Test division with infinity.
    c128 = Complex(real: .infinity, imaginary: .infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: 0) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -0.0) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .nan) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: 0) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -0.0) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .nan) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: .infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: .infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: .infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: -.infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: -.infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: -.infinity) / 42
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .infinity, imaginary: 0)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .infinity, imaginary: -0.0)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .infinity, imaginary: .nan)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -.infinity, imaginary: 0)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -.infinity, imaginary: -0.0)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -.infinity, imaginary: .nan)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -.infinity, imaginary: .infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: 0, imaginary: .infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -0.0, imaginary: .infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .nan, imaginary: .infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -.infinity, imaginary: -.infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: 0, imaginary: -.infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: -0.0, imaginary: -.infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / Complex(real: .nan, imaginary: -.infinity)
    XCTAssertTrue(c128.isZero)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = 42 / -0.0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: 0) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -0.0) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .nan) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: 0) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -0.0) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .nan) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: .infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: .infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: .infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: .infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: .infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .infinity, imaginary: -.infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -.infinity, imaginary: -.infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: 0, imaginary: -.infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: -0.0, imaginary: -.infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)

    c128 = Complex(real: .nan, imaginary: -.infinity) / 0
    XCTAssertTrue(c128.isInfinite)
    XCTAssertFalse(c128.isNaN)
  }

  func testComplexMagnitude() {
    var c128: Complex128 = 42
    XCTAssertEqual(c128.magnitude, Double.hypot(42, 0))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(42, 0)))

    c128 = -42
    XCTAssertEqual(c128.magnitude, Double.hypot(-42, 0))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(-42, 0)))

    c128 = 42 * .i
    XCTAssertEqual(c128.magnitude, Double.hypot(0, 42))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(0, 42)))

    c128 = -42 * .i
    XCTAssertEqual(c128.magnitude, Double.hypot(0, -42))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(0, -42)))

    c128 = 42 + 42 * .i
    XCTAssertEqual(c128.magnitude, Double.hypot(42, 42))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(42, 42)))

    c128 = 42 - 42 * .i
    XCTAssertEqual(c128.magnitude, Double.hypot(42, -42))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(42, -42)))

    c128 = -42 + 42 * .i
    XCTAssertEqual(c128.magnitude, Double.hypot(-42, 42))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(-42, 42)))

    c128 = -42 - 42 * .i
    XCTAssertEqual(c128.magnitude, Double.hypot(-42, -42))
    XCTAssertEqual(abs(c128), Complex(Double.hypot(-42, -42)))
  }

  func testComplexSquaredMagnitude() {
    var c128: Complex128 = 42
    XCTAssertEqual(c128.squaredMagnitude, c128.magnitude * c128.magnitude)

    c128 = 42 * .i
    XCTAssertEqual(c128.squaredMagnitude, c128.magnitude * c128.magnitude)

    c128 = 42 + 42 * .i
    XCTAssertEqual(c128.squaredMagnitude, c128.magnitude * c128.magnitude,
                   accuracy: 0.000_000_000_001)

    // Test special values.
    let values: [Complex128] = [
      Complex(real: 0, imaginary: 0),
      Complex(real: 0, imaginary: -0.0),
      Complex(real: -0.0, imaginary: 0),
      Complex(real: -0.0, imaginary: -0.0),
      Complex(real: .infinity, imaginary: 0),
      Complex(real: 0, imaginary: .infinity),
      Complex(real: .infinity, imaginary: -0.0),
      Complex(real: -0.0, imaginary: .infinity),
      Complex(real: .infinity, imaginary: .infinity),
      Complex(real: -.infinity, imaginary: 0),
      Complex(real: 0, imaginary: -.infinity),
      Complex(real: -.infinity, imaginary: -0.0),
      Complex(real: -0.0, imaginary: -.infinity),
      Complex(real: -.infinity, imaginary: -.infinity),
      Complex(real: 0, imaginary: .nan),
      Complex(real: .nan, imaginary: 0),
      Complex(real: -0.0, imaginary: .nan),
      Complex(real: .nan, imaginary: -0.0),
      Complex(real: .infinity, imaginary: .nan),
      Complex(real: .nan, imaginary: .infinity),
      Complex(real: -.infinity, imaginary: .nan),
      Complex(real: .nan, imaginary: -.infinity),
      Complex(real: .nan, imaginary: .nan),
    ]
    for v in values {
      XCTAssertTrue(v.squaredMagnitude == v.magnitude * v.magnitude ||
        (v.squaredMagnitude.isNaN && (v.magnitude * v.magnitude).isNaN))
      XCTAssertTrue(v.squaredMagnitude.sign == .plus)
    }
  }

  func testComplexProjection() {
    var c128: Complex128 = 42
    XCTAssertEqual(c128.projection(), c128)
    c128 = 42 * .i
    XCTAssertEqual(c128.projection(), c128)
    c128 = 42 + 42 * .i
    XCTAssertEqual(c128.projection(), c128)

    // Test special values.
    let values: [Complex128] = [
      Complex(real: 0, imaginary: 0),
      Complex(real: 0, imaginary: -0.0),
      Complex(real: -0.0, imaginary: 0),
      Complex(real: -0.0, imaginary: -0.0),
      Complex(real: .infinity, imaginary: 0),
      Complex(real: 0, imaginary: .infinity),
      Complex(real: .infinity, imaginary: -0.0),
      Complex(real: -0.0, imaginary: .infinity),
      Complex(real: .infinity, imaginary: .infinity),
      Complex(real: -.infinity, imaginary: 0),
      Complex(real: 0, imaginary: -.infinity),
      Complex(real: -.infinity, imaginary: -0.0),
      Complex(real: -0.0, imaginary: -.infinity),
      Complex(real: -.infinity, imaginary: -.infinity),
      Complex(real: 0, imaginary: .nan),
      Complex(real: .nan, imaginary: 0),
      Complex(real: -0.0, imaginary: .nan),
      Complex(real: .nan, imaginary: -0.0),
      Complex(real: .infinity, imaginary: .nan),
      Complex(real: .nan, imaginary: .infinity),
      Complex(real: -.infinity, imaginary: .nan),
      Complex(real: .nan, imaginary: -.infinity),
      Complex(real: .nan, imaginary: .nan),
    ]
    for v in values {
      if v.isInfinite {
        XCTAssertTrue(v.projection().isInfinite &&
          v.projection().real.sign == .plus &&
          v.projection().imaginary.isZero &&
          v.projection().imaginary.sign == v.imaginary.sign)
      } else if v.isNaN {
        XCTAssertTrue(v.projection().isNaN)
      } else {
        XCTAssertEqual(v.projection(), v)
      }
    }
  }

  func testComplexReciprocal() {
    var c128: Complex128 = 42
    XCTAssertEqual(c128 * c128.reciprocal(), 1)
    XCTAssertEqual(c128.reciprocal().real, 1 / 42)
    XCTAssertTrue(c128.reciprocal().imaginary.isZero)

    c128 = 42 * .i
    XCTAssertTrue(c128.real.isZero)
    XCTAssertEqual(c128 * c128.reciprocal(), 1)
    XCTAssertTrue(c128.reciprocal().real.isZero)
    XCTAssertEqual(c128.reciprocal().imaginary, -1 / 42)

    c128 = 42 + 42 * .i
    XCTAssertEqual(c128 * c128.reciprocal(), 1)

    // Test special values.
    XCTAssertTrue(Complex128(real: 0, imaginary: 0).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: -0.0, imaginary: 0).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: 0, imaginary: -0.0).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: -0.0, imaginary: -0.0).reciprocal().isNaN)
    
    XCTAssertTrue(Complex128(real: .infinity, imaginary: 0).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: 0, imaginary: .infinity).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: -.infinity, imaginary: 0).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: 0, imaginary: -.infinity).reciprocal().isNaN)

    XCTAssertTrue(
      Complex128(real: .infinity, imaginary: -.infinity).reciprocal().isNaN)
    XCTAssertTrue(
      Complex128(real: -.infinity, imaginary: .infinity).reciprocal().isNaN)

    XCTAssertTrue(
      Complex128(real: .infinity, imaginary: .nan).reciprocal().isNaN)
    XCTAssertTrue(
      Complex128(real: .nan, imaginary: .infinity).reciprocal().isNaN)
    XCTAssertTrue(
      Complex128(real: -.infinity, imaginary: .nan).reciprocal().isNaN)
    XCTAssertTrue(
      Complex128(real: .nan, imaginary: -.infinity).reciprocal().isNaN)

    XCTAssertTrue(Complex128(real: 0, imaginary: .nan).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: .nan, imaginary: 0).reciprocal().isNaN)
    XCTAssertTrue(Complex128(real: .nan, imaginary: .nan).reciprocal().isNaN)
  }

  func testComplexLogarithm() {
    let a = Complex128(r: 1, theta: .pi / 4)
    XCTAssertEqual(Complex.log(a).real, 0)
    XCTAssertEqual(Complex.log(a).imaginary, a.argument)

    let b = Complex128(r: 1, theta: .pi / 2)
    XCTAssertEqual(Complex.log(b).real, 0)
    XCTAssertEqual(Complex.log(b).imaginary, b.argument)

    let c = Complex128(r: 1, theta: .pi)
    XCTAssertEqual(Complex.log(c).real, 0)
    XCTAssertEqual(Complex.log(c).imaginary, c.argument)

    let d = Complex128(real: -1, imaginary: 0)
    XCTAssertEqual(Complex.log(d).real, 0)
    XCTAssertEqual(Complex.log(d).imaginary, d.argument)

    let e = d.conjugate()
    XCTAssertEqual(Complex.log(e), Complex.log(d).conjugate())

    let f = Complex128(r: 1, theta: .pi / 2)
    XCTAssertEqual(Complex.log10(f).real, 0)
    XCTAssertEqual(Complex.log10(f).imaginary, .pi / 2 / log(10))

    let g = Complex128(r: 1, theta: .pi / 4)
    XCTAssertEqual(Complex.log10(g).real, 0)
    XCTAssertEqual(Complex.log10(g).imaginary, .pi / 4 / log(10),
                   accuracy: 0.000_000_000_001)

    let h = Complex128(r: 1, theta: .pi)
    XCTAssertEqual(Complex.log10(h).real, 0)
    XCTAssertEqual(Complex.log10(h).imaginary, .pi / log(10))

    let i = h.conjugate()
    XCTAssertEqual(Complex.log10(i).real, 0)
    XCTAssertEqual(Complex.log10(i).imaginary, -.pi / log(10))

    // Test special values.
    var result: Complex128
    result = Complex.log(nzpz)
    XCTAssertEqual(result.real, -.infinity)
    XCTAssertEqual(result.imaginary, .pi)
    // Divide-by-zero flag should be raised.

    result = Complex.log(pzpz)
    XCTAssertEqual(result.real, -.infinity)
    XCTAssertTrue(result.imaginary.isZero)
    XCTAssertTrue(result.imaginary.sign == .plus)
    // Divide-by-zero flag should be raised.

    result = Complex.log(pxpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.log(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.log(nipy)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi)

    result = Complex.log(pipy)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isZero)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.log(nipi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi * 3 / 4)

    result = Complex.log(pipi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi / 4)

    result = Complex.log(pipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.log(nipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.log(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.log(pnpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.log(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
  }

  func testComplexSquareRoot() {
    let a: Complex128 = -4
    XCTAssertEqual(Complex.sqrt(a), 2 * .i)
    XCTAssertEqual(sqrt(a), 2 * .i)
    let b: Complex128 = 4
    XCTAssertEqual(Complex.sqrt(b), 2)
    XCTAssertEqual(sqrt(b), 2)

    // Test special values.
    var result: Complex128
    result = Complex.sqrt(pzpz)
    XCTAssertTrue(result.isZero)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.sqrt(nzpz)
    XCTAssertTrue(result.isZero)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.sqrt(pxpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .infinity)

    result = Complex.sqrt(pnpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .infinity)

    result = Complex.sqrt(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sqrt(nipy)
    XCTAssertEqual(result.real, 0)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertEqual(result.imaginary, .infinity)

    result = Complex.sqrt(pipy)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, 0)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.sqrt(nipn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isInfinite)
    // The sign of the imaginary part is unspecified.

    result = Complex.sqrt(pipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sqrt(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sqrt(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    // Test special values using free function.
    result = sqrt(pzpz)
    XCTAssertTrue(result.isZero)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = sqrt(nzpz)
    XCTAssertTrue(result.isZero)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = sqrt(pxpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .infinity)

    result = sqrt(pnpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .infinity)

    result = sqrt(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = sqrt(nipy)
    XCTAssertEqual(result.real, 0)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertEqual(result.imaginary, .infinity)

    result = sqrt(pipy)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, 0)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = sqrt(nipn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isInfinite)
    // The sign of the imaginary part is unspecified.

    result = sqrt(pipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = sqrt(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = sqrt(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
  }

  func testComplexCubeRoot() {
    // Note that the principal cube root is not necessarily the real-valued
    // cube root.
    let a: Complex64 = -8
    XCTAssertEqual(Complex.cbrt(a).real, 1, accuracy: 0.000001)
    XCTAssertEqual(Complex.cbrt(a).imaginary, 2 * Float.sin(.pi / 3),
                   accuracy: 0.000001)

    let b: Complex64 = 8
    XCTAssertEqual(Complex.cbrt(b), 2)

    let c: Complex64 = -27 * .i
    XCTAssertEqual(Complex.cbrt(c).real, 3 * Float.cos(-.pi / 6),
                   accuracy: 0.000001)
    XCTAssertEqual(Complex.cbrt(c).imaginary, -1.5, accuracy: 0.000001)

    let d: Complex64 = 27 * .i
    XCTAssertEqual(Complex.cbrt(d), Complex.cbrt(c).conjugate())

    let e: Complex128 = -8
    XCTAssertEqual(Complex.cbrt(e), 2 * Complex.exp(.i * .pi / 3))
  }

  func testComplexExponentiation() {
    let a = Complex(real: Double.log(42))
    let b = Complex.exp(a)
    XCTAssertEqual(b.real, 42, accuracy: 0.00000000000001)

    let i: Complex128 = .i
    let actual = Complex.pow(i, i)
    XCTAssertEqual(actual.real, Double.exp(-Double.pi / 2))
    XCTAssertEqual(actual.imaginary, 0)

    // Test special values.
    var result: Complex128
    var expected: Complex128

    result = Complex.exp(pzpz)
    XCTAssertEqual(result.real, 1)
    XCTAssertEqual(result.imaginary, 0)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.exp(nzpz)
    XCTAssertEqual(result.real, 1)
    XCTAssertEqual(result.imaginary, 0)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.exp(pxpi)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.exp(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.exp(pipz)
    XCTAssertTrue(result == pipz)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.exp(nipy)
    expected = Complex(r: 0, theta: nipy.imaginary)
    XCTAssertEqual(result.real, expected.real)
    XCTAssertEqual(result.imaginary, expected.imaginary)

    result = Complex.exp(pipy)
    expected = Complex(r: .infinity, theta: pipy.imaginary)
    XCTAssertEqual(result.real, expected.real)
    XCTAssertEqual(result.imaginary, expected.imaginary)

    result = Complex.exp(nipi)
    XCTAssertTrue(result.isZero)
    // The signs of zero are unspecified.

    result = Complex.exp(pipi)
    XCTAssertTrue(result.real.isInfinite)
    // The sign of the real part is unspecified.
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.exp(nipn)
    XCTAssertTrue(result.isZero)
    // The signs of zero are unspecified.

    result = Complex.exp(pipn)
    XCTAssertTrue(result.real.isInfinite)
    // The sign of the real part is unspecified.
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.exp(pnpz)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertEqual(result.imaginary, pnpz.imaginary)

    result = Complex.exp(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.exp(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
  }

  func testComplexTrigonometry() {
    let a: Complex128 = 1
    XCTAssertEqual(Complex.sin(a).real, Double.sin(1))
    XCTAssertTrue(Complex.sin(a).imaginary.isZero)
    XCTAssertEqual(Complex.cos(a).real, Double.cos(1))
    XCTAssertTrue(Complex.cos(a).imaginary.isZero)
    XCTAssertEqual(Complex.tan(a).real, Double.tan(1))
    XCTAssertTrue(Complex.tan(a).imaginary.isZero)

    let b: Complex128 = a * .i
    XCTAssertTrue(Complex.sin(b).real.isZero)
    XCTAssertEqual(Complex.sin(b).imaginary, Double.sinh(1))
    XCTAssertEqual(Complex.cos(b).real, Double.cosh(1))
    XCTAssertTrue(Complex.cos(b).imaginary.isZero)
    XCTAssertTrue(Complex.tan(b).real.isZero)
    XCTAssertEqual(Complex.tan(b).imaginary, Double.tanh(1),
                   accuracy: 0.00000000000001)

    let c: Complex128 = -2
    let d: Complex128 = .pi + .i * Complex.log(2 - Complex.sqrt(3))
    let e: Complex128 = .pi / 2 - .i * Complex.log(2 + Complex.sqrt(3))

    XCTAssertTrue(Complex.acos(c).real.sign == .plus)
    XCTAssertEqual(abs(Complex.acos(c).real), abs(d.real),
                   accuracy: 0.00000000000001)
    XCTAssertTrue(Complex.acos(c).imaginary.sign == .minus)
    XCTAssertEqual(abs(Complex.acos(c).imaginary), abs(d.imaginary),
                   accuracy: 0.00000000000001)

    XCTAssertTrue(Complex.asin(c).real.sign == .minus)
    XCTAssertEqual(abs(Complex.asin(c).real), abs(e.real),
                   accuracy: 0.00000000000001)
    XCTAssertTrue(Complex.asin(c).imaginary.sign == .plus)
    XCTAssertEqual(abs(Complex.asin(c).imaginary), abs(e.imaginary),
                   accuracy: 0.00000000000001)

    let f: Complex128 = c.conjugate()
    XCTAssertEqual(Complex.acos(f), Complex.acos(c).conjugate())
    XCTAssertEqual(Complex.asin(f), Complex.asin(c).conjugate())

    let g: Complex128 = Complex(real: +0.0, imaginary: 2.0)
    let h: Complex128 = Complex(real: -0.0, imaginary: 2.0)
    let i: Complex128 = .pi / 2 + .i * Complex.log(3) / 2

    XCTAssertTrue(Complex.atan(g).real.sign == .plus)
    XCTAssertEqual(abs(Complex.atan(g).real), abs(i.real),
                   accuracy: 0.00000000000001)
    XCTAssertTrue(Complex.atan(g).imaginary.sign == .plus)
    XCTAssertEqual(abs(Complex.atan(g).imaginary), abs(i.imaginary),
                   accuracy: 0.00000000000001)
    XCTAssertEqual(.i * Complex.atan(h), (.i * Complex.atan(g)).conjugate())

    // Test special values.
    var result: Complex128
    result = Complex.acos(pzpz)
    XCTAssertEqual(result.real, .pi / 2)
    XCTAssertTrue(result.imaginary.isZero)
    XCTAssertTrue(result.imaginary.sign == .minus)

    result = Complex.acos(nzpz)
    XCTAssertEqual(result.real, .pi / 2)
    XCTAssertTrue(result.imaginary.isZero)
    XCTAssertTrue(result.imaginary.sign == .minus)

    result = Complex.acos(pzpn)
    XCTAssertEqual(result.real, .pi / 2)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acos(nzpn)
    XCTAssertEqual(result.real, .pi / 2)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acos(pxpi)
    XCTAssertEqual(result.real, .pi / 2)
    XCTAssertEqual(result.imaginary, -.infinity)

    result = Complex.acos(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acos(nipy)
    XCTAssertEqual(result.real, .pi)
    XCTAssertEqual(result.imaginary, -.infinity)

    var conjugate = Complex.acos(nipy.conjugate())
    XCTAssertEqual(result.conjugate().real, conjugate.real)
    XCTAssertEqual(result.conjugate().imaginary, conjugate.imaginary)

    result = Complex.acos(pipy)
    XCTAssertTrue(result.real.isZero)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertEqual(result.imaginary, -.infinity)

    conjugate = Complex.acos(pipy.conjugate())
    XCTAssertEqual(result.conjugate().real, conjugate.real)
    XCTAssertTrue(result.conjugate().real.sign == conjugate.real.sign)
    XCTAssertEqual(result.conjugate().imaginary, conjugate.imaginary)

    result = Complex.acos(nipi)
    XCTAssertEqual(result.real, .pi * 3 / 4)
    XCTAssertEqual(result.imaginary, -.infinity)

    result = Complex.acos(pipi)
    XCTAssertEqual(result.real, .pi / 4)
    XCTAssertEqual(result.imaginary, -.infinity)

    result = Complex.acos(pipn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isInfinite)
    // The sign of the imaginary part is unspecified.

    result = Complex.acos(nipn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isInfinite)
    // The sign of the imaginary part is unspecified.

    result = Complex.acos(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acos(pnpi)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertEqual(result.imaginary, -.infinity)

    result = Complex.acos(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
  }

  func testComplexHyperbolicFunctions() {
    let a: Complex128 = Complex(real: 0.0, imaginary: -2.0)
    XCTAssertEqual(Complex.asinh(a).real, Double.log(2 + Double.sqrt(3)),
                   accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.asinh(a).imaginary, -.pi / 2)

    let b: Complex128 = Complex(real: -0.0, imaginary: -2.0)
    XCTAssertEqual(Complex.asinh(b).real, -Double.log(2 + Double.sqrt(3)),
                   accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.asinh(b).imaginary, -.pi / 2)

    let c: Complex128 = 1 + 2 * .i
    let d: Complex128 = Complex.log(c + Complex.sqrt(-2 + 4 * .i))
    XCTAssertEqual(Complex.asinh(c).real, d.real, accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.asinh(c).imaginary, d.imaginary,
                   accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.atanh(c).real, Double.log(8) / 4 - Double.log(2) / 2,
                   accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.atanh(c).imaginary, .pi * 3 / 8)

    let e: Complex128 = 0.5
    XCTAssertEqual(Complex.acosh(e).real, 0, accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.acosh(e).imaginary, 1.047197551196597746,
                   accuracy: 0.00000000000001)

    let f: Complex128 = e.conjugate()
    XCTAssertTrue(Complex.acosh(f).real.sign == Complex.acosh(e).real.sign)
    XCTAssertEqual(Complex.acosh(f).real, 0, accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.acosh(f).imaginary, -Complex.acosh(e).imaginary)

    let g: Complex128 = 1 + .i
    let h: Complex128 =
      Complex.log(g + Complex.pow(-1, 1 / 4) * Complex.sqrt(2 + .i))
    XCTAssertEqual(Complex.acosh(g).real, h.real)
    XCTAssertEqual(Complex.acosh(g).imaginary, h.imaginary)

    let i: Complex128 = .i * Complex.acos(g)
    XCTAssertEqual(Complex.acosh(g), i)

    let j: Complex128 = 2
    XCTAssertEqual(Complex.atanh(j).real, Double.log(3) / 2)
    XCTAssertEqual(Complex.atanh(j).imaginary, .pi / 2)

    let k: Complex128 = j.conjugate()
    XCTAssertEqual(Complex.atanh(k).real, Double.log(3) / 2)
    XCTAssertEqual(Complex.atanh(k).imaginary, -.pi / 2)

    // -------------------------------------------------------------------------
    // TODO: Test sinh, cosh, tanh.
    // -------------------------------------------------------------------------

    // Test special values.
    var result: Complex128
    var expected: Complex128

    result = Complex.asinh(pzpz)
    XCTAssertEqual(result, pzpz)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.asinh(pxpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.asinh(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.asinh(pipy)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.asinh(pipi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi / 4)

    result = Complex.asinh(pipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.asinh(pnpz)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.asinh(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.asinh(pnpi)
    XCTAssertTrue(result.real.isInfinite)
    // The sign of the real part is unspecified.
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.asinh(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acosh(pzpz)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.acosh(nzpz)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.acosh(pxpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.acosh(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acosh(pzpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertEqual(result.imaginary, .pi / 2) // See C11 DR 471.

    result = Complex.acosh(nipy)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi)

    var conjugate = Complex.acosh(nipy.conjugate())
    XCTAssertEqual(result.conjugate().real, conjugate.real)
    XCTAssertEqual(result.conjugate().imaginary, conjugate.imaginary)

    result = Complex.acosh(pipy)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    conjugate = Complex.acosh(pipy.conjugate())
    XCTAssertEqual(result.conjugate().real, conjugate.real)
    XCTAssertTrue(result.conjugate().imaginary.sign == conjugate.imaginary.sign)
    XCTAssertEqual(result.conjugate().imaginary, conjugate.imaginary)

    result = Complex.acosh(nipi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi * 3 / 4)

    conjugate = Complex.acosh(nipi.conjugate())
    XCTAssertEqual(result.conjugate().real, conjugate.real)
    XCTAssertEqual(result.conjugate().imaginary, conjugate.imaginary)

    result = Complex.acosh(pipi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertEqual(result.imaginary, .pi / 4)

    conjugate = Complex.acosh(pipi.conjugate())
    XCTAssertEqual(result.conjugate().real, conjugate.real)
    XCTAssertEqual(result.conjugate().imaginary, conjugate.imaginary)

    result = Complex.acosh(pipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acosh(nipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acosh(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acosh(pnpi)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.acosh(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.atanh(pzpz)
    XCTAssertEqual(result, pzpz)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.imaginary.sign == .plus)

    result = Complex.atanh(pzpn)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.atanh(1)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)
    // Divide-by-zero flag should be raised.

    result = Complex.atanh(pxpi)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.atanh(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.atanh(pipy)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.atanh(pipi)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.atanh(pipn)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.atanh(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.atanh(pnpi)
    XCTAssertTrue(result.real.isZero)
    // The sign of the real part is unspecified.
    XCTAssertEqual(result.imaginary, .pi / 2)

    result = Complex.atanh(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sinh(pzpz)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.sinh(pzpi)
    XCTAssertTrue(result.real.isZero)
    // The sign of the real part is unspecified.
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.sinh(pzpn)
    XCTAssertTrue(result.real.isZero)
    // The sign of the real part is unspecified (?).
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sinh(pxpi)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.sinh(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sinh(pipz)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.sinh(pipy)
    expected = Complex(r: .infinity, theta: pipy.imaginary)
    XCTAssertEqual(result.real, expected.real)
    XCTAssertEqual(result.imaginary, expected.imaginary)

    result = Complex.sinh(pipi)
    XCTAssertTrue(result.real.isInfinite)
    // The sign of the real part is unspecified.
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.sinh(pipn)
    XCTAssertTrue(result.real.isInfinite)
    // The sign of the real part is unspecified.
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sinh(pnpz)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.sinh(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.sinh(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.cosh(pzpz)
    XCTAssertEqual(result.real, 1)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.cosh(pzpi)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isZero)
    // The sign of the imaginary part is unspecified.
    // Invalid flag should be raised.

    result = Complex.cosh(pzpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isZero)
    // The sign of the imaginary part is unspecified.

    result = Complex.cosh(pxpi)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.cosh(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.cosh(pipz)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.cosh(pipy)
    expected = Complex(r: .infinity, theta: pipy.imaginary)
    XCTAssertEqual(result.real, expected.real)
    XCTAssertEqual(result.imaginary, expected.imaginary)

    result = Complex.cosh(pipi)
    XCTAssertTrue(result.real.isInfinite)
    // The sign of the real part is unspecified.
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.cosh(pipn)
    XCTAssertEqual(result.real, .infinity)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.cosh(pnpz)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isZero)
    // The sign of the imaginary part is unspecified.

    result = Complex.cosh(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.cosh(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.tanh(pzpz)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertTrue(result.real.isZero)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.tanh(pzpn)
    XCTAssertTrue(result.real.isZero) // See C11 DR 471.
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should *not* be raised.

    result = Complex.tanh(pzpi)
    XCTAssertTrue(result.real.isZero) // See C11 DR 471.
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.tanh(pxpi)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
    // Invalid flag should be raised.

    result = Complex.tanh(pxpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.tanh(pipy)
    XCTAssertEqual(result.real, 1)
    XCTAssertEqual(result.imaginary, 0 * .sin(2 * pipy.imaginary))
    XCTAssertTrue(result.imaginary.sign == (0 * .sin(2 * pipy.imaginary)).sign)

    conjugate = Complex.tanh(pipy.conjugate())
    XCTAssertEqual(conjugate.real, result.conjugate().real)
    XCTAssertEqual(conjugate.imaginary, result.conjugate().imaginary)
    XCTAssertTrue(conjugate.imaginary.sign == result.conjugate().imaginary.sign)

    let negated = Complex.tanh(-pipy)
    XCTAssertEqual(negated.real, (-result).real)
    XCTAssertEqual(negated.imaginary, (-result).imaginary)
    XCTAssertTrue(negated.imaginary.sign == (-result).imaginary.sign)

    result = Complex.tanh(pipi)
    XCTAssertEqual(result.real, 1)
    XCTAssertTrue(result.imaginary.isZero)
    // The sign of the imaginary part is unspecified.

    result = Complex.tanh(pipn)
    XCTAssertEqual(result.real, 1)
    XCTAssertTrue(result.imaginary.isZero)
    // The sign of the imaginary part is unspecified.

    result = Complex.tanh(-pipi)
    XCTAssertEqual(result.real, -1)
    XCTAssertTrue(result.imaginary.isZero)
    // The sign of the imaginary part is unspecified.

    result = Complex.tanh(-pipn)
    XCTAssertEqual(result.real, -1)
    XCTAssertTrue(result.imaginary.isZero)
    // The sign of the imaginary part is unspecified.

    result = Complex.tanh(pnpz)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.sign == .plus)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.tanh(pnpy)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.tanh(pnpn)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    let w = Complex128(real: .greatestFiniteMagnitude)

    result = Complex.tanh(w)
    XCTAssertEqual(result.real, 1)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.tanh(-w)
    XCTAssertEqual(result.real, -1)
    XCTAssertTrue(result.imaginary.isZero)

    let x = Complex128(
      real: .greatestFiniteMagnitude,
      imaginary: .greatestFiniteMagnitude
    )

    result = Complex.tanh(x)
    XCTAssertEqual(result.real, 1)
    XCTAssertTrue(result.imaginary.isZero)

    result = Complex.tanh(-x)
    XCTAssertEqual(result.real, -1)
    XCTAssertTrue(result.imaginary.isZero)

    let y = Complex128(real: .greatestFiniteMagnitude, imaginary: .infinity)

    result = Complex.tanh(y)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.tanh(-y)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    let z = Complex128(real: .greatestFiniteMagnitude, imaginary: .nan)

    result = Complex.tanh(z)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)

    result = Complex.tanh(-z)
    XCTAssertTrue(result.real.isNaN)
    XCTAssertTrue(result.imaginary.isNaN)
  }

  static var allTests = [
    ("testComplexInitialization", testComplexInitialization),
    ("testComplexConstants", testComplexConstants),
    ("testComplexBooleanProperties", testComplexBooleanProperties),
    ("testComplexDescription", testComplexDescription),
    ("testComplexNegation", testComplexNegation),
    ("testComplexAddition", testComplexAddition),
    ("testComplexDivision", testComplexDivision),
    ("testComplexInfinity", testComplexInfinity),
    ("testComplexMagnitude", testComplexMagnitude),
    ("testComplexSquaredMagnitude", testComplexSquaredMagnitude),
    ("testComplexProjection", testComplexProjection),
    ("testComplexReciprocal", testComplexReciprocal),
    ("testComplexLogarithm", testComplexLogarithm),
    ("testComplexSquareRoot", testComplexSquareRoot),
    ("testComplexCubeRoot", testComplexCubeRoot),
    ("testComplexExponentiation", testComplexExponentiation),
    ("testComplexTrigonometry", testComplexTrigonometry),
    ("testComplexHyperbolicFunctions", testComplexHyperbolicFunctions),
  ]
}
