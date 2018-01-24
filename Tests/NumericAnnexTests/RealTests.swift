import XCTest
@testable import NumericAnnex

/// A type that wraps `Double` and implements the methods required for
/// conformance to `Real`.
struct MockReal {
  var _value: Double

  init(_ value: Double) {
    self._value = value
  }
}

extension MockReal : ExpressibleByIntegerLiteral {
  init(integerLiteral value: Double.IntegerLiteralType) {
    self = MockReal(Double(integerLiteral: value))
  }
}

extension MockReal : Hashable {
  var hashValue: Int {
    return _value.hashValue
  }
}

extension MockReal : Strideable {
  func distance(to other: MockReal) -> MockReal {
    return MockReal(_value.distance(to: other._value))
  }

  func advanced(by n: MockReal) -> MockReal {
    return MockReal(_value.advanced(by: n._value))
  }
}

#if !swift(>=4.1)
extension MockReal : _Strideable { }
#endif

extension MockReal : Numeric {
  var magnitude: MockReal {
    return MockReal(_value.magnitude)
  }

  init?<T>(exactly source: T) where T : BinaryInteger {
    guard let d = Double(exactly: source) else { return nil }
    self = MockReal(d)
  }

  static func + (lhs: MockReal, rhs: MockReal) -> MockReal {
    return MockReal(lhs._value + rhs._value)
  }

  static func += (lhs: inout MockReal, rhs: MockReal) {
    lhs._value += rhs._value
  }

  static func - (lhs: MockReal, rhs: MockReal) -> MockReal {
    return MockReal(lhs._value - rhs._value)
  }

  static func -= (lhs: inout MockReal, rhs: MockReal) {
    lhs._value -= rhs._value
  }

  static func * (lhs: MockReal, rhs: MockReal) -> MockReal {
    return MockReal(lhs._value * rhs._value)
  }

  static func *= (lhs: inout MockReal, rhs: MockReal) {
    lhs._value *= rhs._value
  }
}

extension MockReal : FloatingPoint {
#if swift(>=4.1)
  init<T : BinaryInteger>(_ value: T) {
    self = MockReal(Double(value))
  }
#endif

  init(_ value: Int) {
    self = MockReal(Double(value))
  }

  init(_ value: Int8) {
    self = MockReal(Double(value))
  }

  init(_ value: Int16) {
    self = MockReal(Double(value))
  }
  
  init(_ value: Int32) {
    self = MockReal(Double(value))
  }

  init(_ value: Int64) {
    self = MockReal(Double(value))
  }

  init(_ value: UInt) {
    self = MockReal(Double(value))
  }

  init(_ value: UInt8) {
    self = MockReal(Double(value))
  }

  init(_ value: UInt16) {
    self = MockReal(Double(value))
  }

  init(_ value: UInt32) {
    self = MockReal(Double(value))
  }

  init(_ value: UInt64) {
    self = MockReal(Double(value))
  }

  init(sign: FloatingPointSign, exponent: Int, significand: MockReal) {
    self = MockReal(
      Double(sign: sign, exponent: exponent, significand: significand._value)
    )
  }

  init(signOf s: MockReal, magnitudeOf m: MockReal) {
    self = MockReal(Double(signOf: s._value, magnitudeOf: m._value))
  }

  static var greatestFiniteMagnitude = MockReal(.greatestFiniteMagnitude)

  static var infinity = MockReal(.infinity)

  static var leastNonzeroMagnitude = MockReal(.leastNonzeroMagnitude)

  static var leastNormalMagnitude = MockReal(.leastNormalMagnitude)

  static var nan = MockReal(.nan)

  static var pi = MockReal(.pi)

  static var radix = Double.radix

  static var signalingNaN = MockReal(.signalingNaN)

  static func / (lhs: MockReal, rhs: MockReal) -> MockReal {
    return MockReal(lhs._value / rhs._value)
  }

  static func /= (lhs: inout MockReal, rhs: MockReal) {
    lhs._value /= rhs._value
  }

  static prefix func - (x: MockReal) -> MockReal {
    return MockReal(-x._value)
  }

  var exponent: Int {
    return _value.exponent
  }

  var isCanonical: Bool {
    return _value.isCanonical
  }

  var isFinite: Bool {
    return _value.isFinite
  }

  var isInfinite: Bool {
    return _value.isInfinite
  }

  var isNaN: Bool {
    return _value.isNaN
  }

  var isNormal: Bool {
    return _value.isNormal
  }

  var isSignalingNaN: Bool {
    return _value.isSignalingNaN
  }

  var isSubnormal: Bool {
    return _value.isSubnormal
  }

  var isZero: Bool {
    return _value.isZero
  }

  var nextUp: MockReal {
    return MockReal(_value.nextUp)
  }

  var sign: FloatingPointSign {
    return _value.sign
  }

  var significand: MockReal {
    return MockReal(_value.significand)
  }

  var ulp: MockReal {
    return MockReal(_value.ulp)
  }

  mutating func addProduct(_ lhs: MockReal, _ rhs: MockReal) {
    _value.addProduct(lhs._value, rhs._value)
  }

  mutating func formRemainder(dividingBy other: MockReal) {
    _value.formRemainder(dividingBy: other._value)
  }

  mutating func formSquareRoot() {
    _value.formSquareRoot()
  }

  mutating func formTruncatingRemainder(dividingBy other: MockReal) {
    _value.formTruncatingRemainder(dividingBy: other._value)
  }

  func isEqual(to other: MockReal) -> Bool {
    return _value.isEqual(to: other._value)
  }

  func isLess(than other: MockReal) -> Bool {
    return _value.isLess(than: other._value)
  }

  func isLessThanOrEqualTo(_ other: MockReal) -> Bool {
    return _value.isLessThanOrEqualTo(other._value)
  }

  func isTotallyOrdered(belowOrEqualTo other: MockReal) -> Bool {
    return _value.isTotallyOrdered(belowOrEqualTo: other._value)
  }

  mutating func negate() {
    _value.negate()
  }

  mutating func round(_ rule: FloatingPointRoundingRule) {
    _value.round(rule)
  }
}

extension MockReal : Real {
  static func ** (lhs: MockReal, rhs: MockReal) -> MockReal {
    return MockReal(lhs._value ** rhs._value)
  }

  static func **= (lhs: inout MockReal, rhs: MockReal) {
    lhs = lhs ** rhs
  }

  func naturalExponential() -> MockReal {
    return MockReal(_value.naturalExponential())
  }

  func naturalLogarithm() -> MockReal {
    return MockReal(_value.naturalLogarithm())
  }

  func sine() -> MockReal {
    return MockReal(_value.sine())
  }

  func cosine() -> MockReal {
    return MockReal(_value.cosine())
  }

  func inverseSine() -> MockReal {
    return MockReal(_value.inverseSine())
  }

  func inverseCosine() -> MockReal {
    return MockReal(_value.inverseCosine())
  }

  func inverseTangent() -> MockReal {
    return MockReal(_value.inverseTangent())
  }

  func hyperbolicSine() -> MockReal {
    return MockReal(_value.hyperbolicSine())
  }

  func hyperbolicCosine() -> MockReal {
    return MockReal(_value.hyperbolicCosine())
  }

  func inverseHyperbolicSine() -> MockReal {
    return MockReal(_value.inverseHyperbolicSine())
  }

  func inverseHyperbolicCosine() -> MockReal {
    return MockReal(_value.inverseHyperbolicCosine())
  }

  func inverseHyperbolicTangent() -> MockReal {
    return MockReal(_value.inverseHyperbolicTangent())
  }

  func error() -> MockReal {
    return MockReal(_value.error())
  }

  func complementaryError() -> MockReal {
    return MockReal(_value.complementaryError())
  }

  func gamma() -> MockReal {
    return MockReal(_value.gamma())
  }

  func logarithmicGamma() -> MockReal {
    return MockReal(_value.logarithmicGamma())
  }
}

class RealTests: XCTestCase {
  func testTranscendentalConstants() {
    XCTAssertEqual(Double.pi, MockReal.pi._value)
    XCTAssertEqual(Double.e, MockReal.e._value,
                   accuracy: abs(Double.e * 0.000_000_000_001))
    XCTAssertEqual(Double.phi, MockReal.phi._value,
                   accuracy: abs(Double.phi * 0.000_000_000_001))
  }

  func testExp2() {
    for i in -42...42 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.exp2(d), MockReal.exp2(m)._value,
                     accuracy: abs(Double.exp2(d) * 0.000_000_000_001))
    }
  }

  func testExp10() {
    for i in -42...42 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.exp10(d), MockReal.exp10(m)._value,
                     accuracy: abs(Double.exp10(d) * 0.000_000_000_001))
    }
  }

  func testExpm1() {
    for i in -42...42 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.expm1(d), MockReal.expm1(m)._value,
                     accuracy: abs(Double.expm1(d) * 0.000_000_000_001))
    }
  }

  func testLog2() {
    for i in 1...85 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.log2(d), MockReal.log2(m)._value,
                     accuracy: abs(Double.log2(d) * 0.000_000_000_001))
    }
  }

  func testLog10() {
    for i in 1...85 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.log10(d), MockReal.log10(m)._value,
                     accuracy: abs(Double.log10(d) * 0.000_000_000_001))
    }
  }

  func testLog1p() {
    for i in 1...85 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.log1p(d), MockReal.log1p(m)._value,
                     accuracy: abs(Double.log1p(d) * 0.000_000_000_001))
    }
  }

  func testCbrt() {
    for i in -42...42 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.cbrt(d), MockReal.cbrt(m)._value,
                     accuracy: abs(Double.cbrt(d) * 0.000_000_000_001))
    }
  }

  func testTan() {
    for i in -42...42 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.tan(d), MockReal.tan(m)._value,
                     accuracy: abs(Double.tan(d) * 0.000_000_000_001))
    }
  }

  func testTanh() {
    for i in -42...42 {
      let d = Double(i)
      let m = MockReal(d)
      XCTAssertEqual(Double.tanh(d), MockReal.tanh(m)._value,
                     accuracy: abs(Double.tanh(d) * 0.000_000_000_001))
    }
  }

  func testHypot() {
    for i in -42...42 {
      let dx = Double(i)
      let mx = MockReal(dx)
      for j in -42...42 {
        let dy = Double(j)
        let my = MockReal(dy)
        XCTAssertEqual(Double.hypot(dx, dy), MockReal.hypot(mx, my)._value,
                       accuracy: abs(Double.hypot(dx, dy) * 0.000_000_000_001))
      }
    }
    // Test special values.
    XCTAssertEqual(MockReal.hypot(.infinity, .nan), .infinity)
    XCTAssertEqual(MockReal.hypot(.infinity, .infinity), .infinity)
    XCTAssertEqual(MockReal.hypot(.infinity, 42), .infinity)
    XCTAssertEqual(MockReal.hypot(42, -.infinity), .infinity)
    XCTAssertEqual(MockReal.hypot(-.infinity, -.infinity), .infinity)
    XCTAssertEqual(MockReal.hypot(.nan, -.infinity), .infinity)
    XCTAssertTrue(MockReal.hypot(.nan, .nan).isNaN)
    XCTAssertTrue(MockReal.hypot(.nan, 42).isNaN)
    XCTAssertTrue(MockReal.hypot(42, .nan).isNaN)
  }

  func testAtan2() {
    for i in -42...42 {
      let dx = Double(i)
      let mx = MockReal(dx)
      for j in -42...42 {
        let dy = Double(j)
        let my = MockReal(dy)
        XCTAssertEqual(Double.atan2(dy, dx), MockReal.atan2(my, mx)._value,
                       accuracy: abs(Double.atan2(dy, dx) * 0.000_000_000_001))
      }
    }
    // Test special values.
    XCTAssertTrue(MockReal.atan2(0, 0).isZero)
    XCTAssertTrue(MockReal.atan2(0, 0).sign == .plus)
    XCTAssertTrue(MockReal.atan2(MockReal(-0.0), 0).isZero)
    XCTAssertTrue(MockReal.atan2(MockReal(-0.0), 0).sign == .minus)
    XCTAssertEqual(MockReal.atan2(0, MockReal(-0.0)), .pi)
    XCTAssertEqual(MockReal.atan2(MockReal(-0.0), MockReal(-0.0)), -.pi)
    XCTAssertEqual(MockReal.atan2(0, -42), .pi)
    XCTAssertEqual(MockReal.atan2(MockReal(-0.0), -42), -.pi)
    XCTAssertTrue(MockReal.atan2(0, 42).isZero)
    XCTAssertTrue(MockReal.atan2(0, 42).sign == .plus)
    XCTAssertTrue(MockReal.atan2(MockReal(-0.0), 42).isZero)
    XCTAssertTrue(MockReal.atan2(MockReal(-0.0), 42).sign == .minus)
    XCTAssertEqual(MockReal.atan2(.infinity, 42), .pi / 2)
    XCTAssertEqual(MockReal.atan2(-.infinity, 42), -.pi / 2)
    XCTAssertEqual(MockReal.atan2(.infinity, -.infinity), 3 * .pi / 4)
    XCTAssertEqual(MockReal.atan2(-.infinity, -.infinity), -3 * .pi / 4)
    XCTAssertEqual(MockReal.atan2(.infinity, .infinity), .pi / 4)
    XCTAssertEqual(MockReal.atan2(-.infinity, .infinity), -.pi / 4)
    XCTAssertEqual(MockReal.atan2(-42, 0), -.pi / 2)
    XCTAssertEqual(MockReal.atan2(-42, MockReal(-0.0)), -.pi / 2)
    XCTAssertEqual(MockReal.atan2(42, 0), .pi / 2)
    XCTAssertEqual(MockReal.atan2(42, MockReal(-0.0)), .pi / 2)
    XCTAssertEqual(MockReal.atan2(42, -.infinity), .pi)
    XCTAssertEqual(MockReal.atan2(-42, -.infinity), -.pi)
    XCTAssertTrue(MockReal.atan2(42, .infinity).isZero)
    XCTAssertTrue(MockReal.atan2(42, .infinity).sign == .plus)
    XCTAssertTrue(MockReal.atan2(-42, .infinity).isZero)
    XCTAssertTrue(MockReal.atan2(-42, .infinity).sign == .minus)
    XCTAssertTrue(MockReal.atan2(.nan, .nan).isNaN)
    XCTAssertTrue(MockReal.atan2(.nan, 42).isNaN)
    XCTAssertTrue(MockReal.atan2(42, .nan).isNaN)
  }

  func testFloat() {
    XCTAssertEqual(((-2 as Float) ** -3), -0.125)
    XCTAssertTrue(((0 as Float) ** 42).isZero)
    XCTAssertTrue(((0 as Float) ** 42).sign == .plus)
    XCTAssertTrue(((-0.0 as Float) ** 42).isZero)
    XCTAssertTrue(((-0.0 as Float) ** 42).sign == .plus)
    XCTAssertTrue(((0 as Float) ** 43).isZero)
    XCTAssertTrue(((0 as Float) ** 43).sign == .plus)
    XCTAssertTrue(((-0.0 as Float) ** 43).isZero)
    XCTAssertTrue(((-0.0 as Float) ** 43).sign == .minus)

    XCTAssertEqual(Float.cbrt(64), 4)
    XCTAssertEqual(Float.cbrt(-64), -4)
    XCTAssertEqual(Float.cbrt(27), 3)
    XCTAssertEqual(Float.cbrt(-27), -3)
    XCTAssertEqual(Float.cbrt(8), 2)
    XCTAssertEqual(Float.cbrt(-8), -2)
    XCTAssertEqual(Float.cbrt(-0.125), -0.5)
    XCTAssertEqual(Float.cbrt(0.125), 0.5)
    XCTAssertEqual(Float.cbrt(-0.015625), -0.25)
    XCTAssertEqual(Float.cbrt(0.015625), 0.25)

    XCTAssertEqual(Float.exp2(0), 1)
    XCTAssertEqual(Float.exp2(2), 4)
    XCTAssertEqual(Float.exp2(4), 16)

    XCTAssertEqual(Float.exp10(0), 1)
    XCTAssertEqual(Float.exp10(2), 100)
    XCTAssertEqual(Float.exp10(4), 10000)

    XCTAssertEqual(Float.expm1(16), .exp(16) - 1)
    XCTAssertTrue(Float.expm1(0).isZero)
    XCTAssertEqual(Float.expm1(-.infinity), -1)
    XCTAssertEqual(Float.expm1(.infinity), .infinity)

    XCTAssertEqual(Float.log2(16), 4)
    XCTAssertEqual(Float.log2(4), 2)
    XCTAssertEqual(Float.log2(1), 0)

    XCTAssertEqual(Float.log10(10000), 4)
    XCTAssertEqual(Float.log10(100), 2)
    XCTAssertEqual(Float.log10(1), 0)

    XCTAssertEqual(Float.log1p(16777216), .log(16777215))
    XCTAssertTrue(Float.log1p(0).isZero)
    XCTAssertEqual(Float.log1p(-1), -.infinity)
    XCTAssertEqual(Float.log1p(.infinity), .infinity)

    XCTAssertEqual(Float.sin(.pi / 2), 1)
    XCTAssertTrue(Float.sin(0).isZero)
    XCTAssertTrue(Float.sin(0).sign == .plus)
    XCTAssertTrue(Float.sin(-0.0).isZero)
    XCTAssertTrue(Float.sin(-0.0).sign == .minus)

    XCTAssertEqual(Float.cos(.pi / 2), 0, accuracy: 0.000_001)
    XCTAssertEqual(Float.cos(0), 1)
    XCTAssertEqual(Float.cos(-0.0), 1)

    XCTAssertEqual(Float.tan(.pi / 4), 1, accuracy: 0.000_001)
    XCTAssertEqual(Float.tan(3 * .pi / 4), -1, accuracy: 0.000_001)
    XCTAssertTrue(Float.tan(0).isZero)
    XCTAssertTrue(Float.tan(0).sign == .plus)
    XCTAssertTrue(Float.tan(-0.0).isZero)
    XCTAssertTrue(Float.tan(-0.0).sign == .minus)

    XCTAssertEqual(Float.asin(1), .pi / 2, accuracy: 0.000_001)
    XCTAssertTrue(Float.asin(0).isZero)
    XCTAssertTrue(Float.asin(0).sign == .plus)
    XCTAssertTrue(Float.asin(-0.0).isZero)
    XCTAssertTrue(Float.asin(-0.0).sign == .minus)

    XCTAssertEqual(Float.acos(0), .pi / 2, accuracy: 0.000_001)
    XCTAssertEqual(Float.acos(1), 0)
    XCTAssertEqual(Float.acos(-1), .pi, accuracy: 0.000_001)

    XCTAssertEqual(Float.atan(1), .pi / 4, accuracy: 0.000_001)
    XCTAssertEqual(Float.atan(-1), -.pi / 4, accuracy: 0.000_001)
    XCTAssertTrue(Float.atan(0).isZero)
    XCTAssertTrue(Float.atan(0).sign == .plus)
    XCTAssertTrue(Float.atan(-0.0).isZero)
    XCTAssertTrue(Float.atan(-0.0).sign == .minus)

    XCTAssertEqual(Float.sinh(1), 1.175201194, accuracy: 0.000_001)
    XCTAssertTrue(Float.sinh(0).isZero)
    XCTAssertTrue(Float.sinh(0).sign == .plus)
    XCTAssertTrue(Float.sinh(-0.0).isZero)
    XCTAssertTrue(Float.sinh(-0.0).sign == .minus)

    XCTAssertEqual(Float.cosh(1), 1.543080635, accuracy: 0.000_001)
    XCTAssertEqual(Float.cosh(0), 1)
    XCTAssertEqual(Float.cosh(-0.0), 1)

    XCTAssertEqual(Float.tanh(1), 0.761594156, accuracy: 0.000_001)
    XCTAssertTrue(Float.tanh(0).isZero)
    XCTAssertTrue(Float.tanh(0).sign == .plus)
    XCTAssertTrue(Float.tanh(-0.0).isZero)
    XCTAssertTrue(Float.tanh(-0.0).sign == .minus)

    XCTAssertEqual(Float.asinh(1), 0.881373587, accuracy: 0.000_001)
    XCTAssertTrue(Float.asinh(0).isZero)
    XCTAssertTrue(Float.asinh(0).sign == .plus)
    XCTAssertTrue(Float.asinh(-0.0).isZero)
    XCTAssertTrue(Float.asinh(-0.0).sign == .minus)

    XCTAssertEqual(Float.acosh(2), 1.316957897, accuracy: 0.000_001)
    XCTAssertEqual(Float.acosh(1), 0)
    XCTAssertEqual(Float.acosh(.infinity), .infinity)

    XCTAssertEqual(Float.atanh(0.5), 0.549306144, accuracy: 0.000_001)
    XCTAssertTrue(Float.atanh(0).isZero)
    XCTAssertTrue(Float.atanh(0).sign == .plus)
    XCTAssertTrue(Float.atanh(-0.0).isZero)
    XCTAssertTrue(Float.atanh(-0.0).sign == .minus)

    XCTAssertEqual(Float.erf(1), 0.842700793, accuracy: 0.000_001)
    XCTAssertTrue(Float.erf(0).isZero)
    XCTAssertTrue(Float.erf(0).sign == .plus)
    XCTAssertTrue(Float.erf(-0.0).isZero)
    XCTAssertTrue(Float.erf(-0.0).sign == .minus)
    XCTAssertEqual(Float.erf(.infinity), 1)
    XCTAssertEqual(Float.erf(-.infinity), -1)

    XCTAssertEqual(Float.erfc(1), 0.157299207, accuracy: 0.000_001)
    XCTAssertEqual(Float.erfc(0), 1)
    XCTAssertEqual(Float.erfc(.infinity), 0)
    XCTAssertEqual(Float.erfc(-.infinity), 2)

    XCTAssertEqual(Float.tgamma(10), Float((2...9).reduce(1, *)), accuracy: 0.1)
    XCTAssertEqual(Float.tgamma(1), 1)
    XCTAssertEqual(Float.tgamma(.infinity), .infinity)

    XCTAssertEqual(Float.lgamma(10), Float.log(Float((2...9).reduce(1, *))),
                   accuracy: 0.000_001)
    XCTAssertEqual(Float.lgamma(1), 0)
    XCTAssertEqual(Float.lgamma(.infinity), .infinity)
  }

  func testDouble() {
    XCTAssertEqual(((-2 as Double) ** -3), -0.125)
    XCTAssertTrue(((0 as Double) ** 42).isZero)
    XCTAssertTrue(((0 as Double) ** 42).sign == .plus)
    XCTAssertTrue(((-0.0 as Double) ** 42).isZero)
    XCTAssertTrue(((-0.0 as Double) ** 42).sign == .plus)
    XCTAssertTrue(((0 as Double) ** 43).isZero)
    XCTAssertTrue(((0 as Double) ** 43).sign == .plus)
    XCTAssertTrue(((-0.0 as Double) ** 43).isZero)
    XCTAssertTrue(((-0.0 as Double) ** 43).sign == .minus)

    XCTAssertEqual(Double.cbrt(64), 4)
    XCTAssertEqual(Double.cbrt(-64), -4)
    XCTAssertEqual(Double.cbrt(27), 3, accuracy: 0.000_001)
    XCTAssertEqual(Double.cbrt(-27), -3, accuracy: 0.000_001)
    XCTAssertEqual(Double.cbrt(8), 2)
    XCTAssertEqual(Double.cbrt(-8), -2)
    XCTAssertEqual(Double.cbrt(-0.125), -0.5, accuracy: 0.000_001)
    XCTAssertEqual(Double.cbrt(0.125), 0.5, accuracy: 0.000_001)
    XCTAssertEqual(Double.cbrt(-0.015625), -0.25, accuracy: 0.000_001)
    XCTAssertEqual(Double.cbrt(0.015625), 0.25, accuracy: 0.000_001)

    XCTAssertEqual(Double.exp2(0), 1)
    XCTAssertEqual(Double.exp2(2), 4)
    XCTAssertEqual(Double.exp2(4), 16)

    XCTAssertEqual(Double.exp10(0), 1)
    XCTAssertEqual(Double.exp10(2), 100)
    XCTAssertEqual(Double.exp10(4), 10000, accuracy: 0.000_001)

    XCTAssertEqual(Double.expm1(16), .exp(16) - 1)
    XCTAssertTrue(Double.expm1(0).isZero)
    XCTAssertEqual(Double.expm1(-.infinity), -1)
    XCTAssertEqual(Double.expm1(.infinity), .infinity)

    XCTAssertEqual(Double.log2(16), 4)
    XCTAssertEqual(Double.log2(4), 2)
    XCTAssertEqual(Double.log2(1), 0)

    XCTAssertEqual(Double.log10(10000), 4)
    XCTAssertEqual(Double.log10(100), 2)
    XCTAssertEqual(Double.log10(1), 0)

    XCTAssertEqual(Double.log1p(16777216), .log(16777215), accuracy: 0.000_001)
    XCTAssertTrue(Double.log1p(0).isZero)
    XCTAssertEqual(Double.log1p(-1), -.infinity)
    XCTAssertEqual(Double.log1p(.infinity), .infinity)

    XCTAssertEqual(Double.sin(.pi / 2), 1)
    XCTAssertTrue(Double.sin(0).isZero)
    XCTAssertTrue(Double.sin(0).sign == .plus)
    XCTAssertTrue(Double.sin(-0.0).isZero)
    XCTAssertTrue(Double.sin(-0.0).sign == .minus)

    XCTAssertEqual(Double.cos(.pi / 2), 0, accuracy: 0.000_000_000_001)
    XCTAssertEqual(Double.cos(0), 1)
    XCTAssertEqual(Double.cos(-0.0), 1)

    XCTAssertEqual(Double.tan(.pi / 4), 1, accuracy: 0.000_000_000_001)
    XCTAssertEqual(Double.tan(3 * .pi / 4), -1, accuracy: 0.000_000_000_001)
    XCTAssertTrue(Double.tan(0).isZero)
    XCTAssertTrue(Double.tan(0).sign == .plus)
    XCTAssertTrue(Double.tan(-0.0).isZero)
    XCTAssertTrue(Double.tan(-0.0).sign == .minus)

    XCTAssertEqual(Double.asin(1), .pi / 2)
    XCTAssertTrue(Double.asin(0).isZero)
    XCTAssertTrue(Double.asin(0).sign == .plus)
    XCTAssertTrue(Double.asin(-0.0).isZero)
    XCTAssertTrue(Double.asin(-0.0).sign == .minus)

    XCTAssertEqual(Double.acos(0), .pi / 2, accuracy: 0.000_000_000_001)
    XCTAssertEqual(Double.acos(1), 0)
    XCTAssertEqual(Double.acos(-1), .pi)

    XCTAssertEqual(Double.atan(1), .pi / 4, accuracy: 0.000_000_000_001)
    XCTAssertEqual(Double.atan(-1), -.pi / 4, accuracy: 0.000_000_000_001)
    XCTAssertTrue(Double.atan(0).isZero)
    XCTAssertTrue(Double.atan(0).sign == .plus)
    XCTAssertTrue(Double.atan(-0.0).isZero)
    XCTAssertTrue(Double.atan(-0.0).sign == .minus)

    XCTAssertEqual(Double.sinh(1), 1.175201193644, accuracy: 0.000_000_000_001)
    XCTAssertTrue(Double.sinh(0).isZero)
    XCTAssertTrue(Double.sinh(0).sign == .plus)
    XCTAssertTrue(Double.sinh(-0.0).isZero)
    XCTAssertTrue(Double.sinh(-0.0).sign == .minus)

    XCTAssertEqual(Double.cosh(1), 1.543080634815, accuracy: 0.000_000_000_001)
    XCTAssertEqual(Double.cosh(0), 1)
    XCTAssertEqual(Double.cosh(-0.0), 1)

    XCTAssertEqual(Double.tanh(1), 0.761594155956, accuracy: 0.000_000_000_001)
    XCTAssertTrue(Double.tanh(0).isZero)
    XCTAssertTrue(Double.tanh(0).sign == .plus)
    XCTAssertTrue(Double.tanh(-0.0).isZero)
    XCTAssertTrue(Double.tanh(-0.0).sign == .minus)

    XCTAssertEqual(Double.asinh(1), 0.881373587020, accuracy: 0.000_000_000_001)
    XCTAssertTrue(Double.asinh(0).isZero)
    XCTAssertTrue(Double.asinh(0).sign == .plus)
    XCTAssertTrue(Double.asinh(-0.0).isZero)
    XCTAssertTrue(Double.asinh(-0.0).sign == .minus)

    XCTAssertEqual(Double.acosh(2), 1.316957896925, accuracy: 0.000_000_000_001)
    XCTAssertEqual(Double.acosh(1), 0)
    XCTAssertEqual(Double.acosh(.infinity), .infinity)

    XCTAssertEqual(Double.atanh(0.5), 0.549306144334,
                   accuracy: 0.000_000_000_001)
    XCTAssertTrue(Double.atanh(0).isZero)
    XCTAssertTrue(Double.atanh(0).sign == .plus)
    XCTAssertTrue(Double.atanh(-0.0).isZero)
    XCTAssertTrue(Double.atanh(-0.0).sign == .minus)

    XCTAssertEqual(Double.erf(1), 0.842700792950, accuracy: 0.000_000_000_001)
    XCTAssertTrue(Double.erf(0).isZero)
    XCTAssertTrue(Double.erf(0).sign == .plus)
    XCTAssertTrue(Double.erf(-0.0).isZero)
    XCTAssertTrue(Double.erf(-0.0).sign == .minus)
    XCTAssertEqual(Double.erf(.infinity), 1)
    XCTAssertEqual(Double.erf(-.infinity), -1)

    XCTAssertEqual(Double.erfc(1), 0.157299207050, accuracy: 0.000_001)
    XCTAssertEqual(Double.erfc(0), 1)
    XCTAssertEqual(Double.erfc(.infinity), 0)
    XCTAssertEqual(Double.erfc(-.infinity), 2)

    XCTAssertEqual(Double.tgamma(10), Double((2...9).reduce(1, *)),
                   accuracy: 0.000_001)
    XCTAssertEqual(Double.tgamma(1), 1)
    XCTAssertEqual(Double.tgamma(.infinity), .infinity)

    XCTAssertEqual(Double.lgamma(10), Double.log(Double((2...9).reduce(1, *))),
                   accuracy: 0.000_000_000_001)
    XCTAssertEqual(Double.lgamma(1), 0)
    XCTAssertEqual(Double.lgamma(.infinity), .infinity)
  }

  static var allTests = [
    ("testTranscendentalConstants", testTranscendentalConstants),
    ("testExp2", testExp2),
    ("testExp10", testExp10),
    ("testExpm1", testExpm1),
    ("testLog2", testLog2),
    ("testLog10", testLog10),
    ("testLog1p", testLog1p),
    ("testCbrt", testCbrt),
    ("testTan", testTan),
    ("testTanh", testTanh),
    ("testHypot", testHypot),
    ("testAtan2", testAtan2),
    ("testFloat", testFloat),
    ("testDouble", testDouble),
  ]
}
