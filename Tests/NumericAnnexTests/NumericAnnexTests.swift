import XCTest
@testable import NumericAnnex

class NumericAnnexTests: XCTestCase {
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

  func testComplexAddition() {
    let foo: Complex128 = 1.0 + 2.0 * .i
    let bar: Complex128 = 2 + 4 * .i
    XCTAssertEqual(foo + bar, 3 + 6 * .i)

    let baz: Complex64 = 1 + 2 * .i
    let boo: Complex64 = 2.0 + 4.0 * .i
    XCTAssertEqual((foo + bar).real, Double((baz + boo).real))
    XCTAssertEqual((foo + bar).imaginary, Double((baz + boo).imaginary))
  }

  func testComplexDivision() {
    let a = 3 + 2 * Complex128.i
    let b = 4 - 3 * Complex128.i
    let c = a / b
    XCTAssertEqual(c.real, 6/25)
    XCTAssertEqual(c.imaginary, 17/25)
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
    let b: Complex128 = 4
    XCTAssertEqual(Complex.sqrt(b), 2)

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
  }

  func testComplexCubeRoot() {
    // Note that the principal cube root is not necessarily the real-valued
    // cube root.
    let a: Complex64 = -8
    XCTAssertEqualWithAccuracy(Complex.cbrt(a).real, 1, accuracy: 0.000001)
    XCTAssertEqualWithAccuracy(Complex.cbrt(a).imaginary,
                               2 * Float.sin(.pi / 3), accuracy: 0.000001)

    let b: Complex64 = 8
    XCTAssertEqual(Complex.cbrt(b), 2)

    let c: Complex64 = -27 * .i
    XCTAssertEqualWithAccuracy(Complex.cbrt(c).real,
                               3 * Float.cos(-.pi / 6), accuracy: 0.000001)
    XCTAssertEqualWithAccuracy(Complex.cbrt(c).imaginary,
                               -1.5, accuracy: 0.000001)

    let d: Complex64 = 27 * .i
    XCTAssertEqual(Complex.cbrt(d), Complex.cbrt(c).conjugate())
  }

  func testComplexExponentiation() {
    let a = Complex(real: Double.log(42))
    let b = Complex.exp(a)
    XCTAssertEqualWithAccuracy(b.real, 42, accuracy: 0.00000000000001)

    let i: Complex128 = .i
    let actual = i.power(of: i)
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
    XCTAssertEqual(Complex.tan(b).imaginary, Double.tanh(1))

    let c: Complex128 = -2
    let d: Complex128 =
      Complex(real: .pi) + .i * Complex.log(2 - Complex.sqrt(3))
    let e: Complex128 =
      Complex(real: .pi / 2) - .i * Complex.log(2 + Complex.sqrt(3))

    XCTAssertTrue(Complex.acos(c).real.sign == .plus)
    XCTAssertEqualWithAccuracy(abs(Complex.acos(c).real), abs(d.real),
                               accuracy: 0.00000000000001)
    XCTAssertTrue(Complex.acos(c).imaginary.sign == .minus)
    XCTAssertEqualWithAccuracy(abs(Complex.acos(c).imaginary), abs(d.imaginary),
                               accuracy: 0.00000000000001)

    XCTAssertTrue(Complex.asin(c).real.sign == .minus)
    XCTAssertEqualWithAccuracy(abs(Complex.asin(c).real), abs(e.real),
                               accuracy: 0.00000000000001)
    XCTAssertTrue(Complex.asin(c).imaginary.sign == .plus)
    XCTAssertEqualWithAccuracy(abs(Complex.asin(c).imaginary), abs(e.imaginary),
                               accuracy: 0.00000000000001)

    let f: Complex128 = c.conjugate()
    XCTAssertEqual(Complex.acos(f), Complex.acos(c).conjugate())
    XCTAssertEqual(Complex.asin(f), Complex.asin(c).conjugate())

    let g: Complex128 = Complex(real: +0.0, imaginary: 2.0)
    let h: Complex128 = Complex(real: -0.0, imaginary: 2.0)
    let i: Complex128 = Complex(real: .pi / 2) + .i * Complex.log(3) / 2

    XCTAssertTrue(Complex.atan(g).real.sign == .plus)
    XCTAssertEqualWithAccuracy(abs(Complex.atan(g).real), abs(i.real),
                               accuracy: 0.00000000000001)
    XCTAssertTrue(Complex.atan(g).imaginary.sign == .plus)
    XCTAssertEqualWithAccuracy(abs(Complex.atan(g).imaginary), abs(i.imaginary),
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

    result = Complex.acos(pipy)
    XCTAssertTrue(result.real.isZero)
    XCTAssertTrue(result.real.sign == .plus)
    XCTAssertEqual(result.imaginary, -.infinity)

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
    XCTAssertEqualWithAccuracy(Complex.asinh(a).real,
                               Double.log(2 + Double.sqrt(3)),
                               accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.asinh(a).imaginary, -.pi / 2)

    let b: Complex128 = Complex(real: -0.0, imaginary: -2.0)
    XCTAssertEqualWithAccuracy(Complex.asinh(b).real,
                               -Double.log(2 + Double.sqrt(3)),
                               accuracy: 0.00000000000001)
    XCTAssertEqual(Complex.asinh(b).imaginary, -.pi / 2)

    let c: Complex128 = 1 + 2 * .i
    let d: Complex128 = Complex.log(c + Complex.sqrt(-2 + 4 * .i))
    print(Complex.pow(c, 2))
    XCTAssertEqualWithAccuracy(Complex.asinh(c).real, d.real,
                               accuracy: 0.00000000000001)
    XCTAssertEqualWithAccuracy(Complex.asinh(c).imaginary, d.imaginary,
                               accuracy: 0.00000000000001)
  }

  static var allTests = [
    ("testComplexAddition", testComplexAddition),
    ("testComplexDivision", testComplexDivision),
    ("testComplexLogarithm", testComplexLogarithm),
    ("testComplexSquareRoot", testComplexSquareRoot),
    ("testComplexCubeRoot", testComplexCubeRoot),
    ("testComplexExponentiation", testComplexExponentiation),
    ("testComplexTrigonometry", testComplexTrigonometry),
    ("testComplexHyperbolicFunctions", testComplexHyperbolicFunctions),
  ]
}
