//
//  FloatingPointMath.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/1/17.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

/// A binary floating-point type that provides a selection of special functions.
///
/// The `FloatingPointMath` protocol provides a suitable basis for writing
/// functions that work on any binary floating-point type that provides the
/// required functions.
public protocol FloatingPointMath : Math, BinaryFloatingPoint /*, Hashable */ {
  /// Creates a new value from the given rational value, after rounding the
  /// whole part and the numerator and denominator of the fractional part each
  /// to the closest possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - value: The rational value to convert to a floating-point value.
  init(_ value: Rational<Int>)

  /// Creates a new value from the given rational value, after rounding the
  /// whole part and the numerator and denominator of the fractional part each
  /// to the closest possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - value: The rational value to convert to a floating-point value.
  init(_ value: Rational<Int8>)

  /// Creates a new value from the given rational value, after rounding the
  /// whole part and the numerator and denominator of the fractional part each
  /// to the closest possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - value: The rational value to convert to a floating-point value.
  init(_ value: Rational<Int16>)

  /// Creates a new value from the given rational value, after rounding the
  /// whole part and the numerator and denominator of the fractional part each
  /// to the closest possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - value: The rational value to convert to a floating-point value.
  init(_ value: Rational<Int32>)

  /// Creates a new value from the given rational value, after rounding the
  /// whole part and the numerator and denominator of the fractional part each
  /// to the closest possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - value: The rational value to convert to a floating-point value.
  init(_ value: Rational<Int64>)

  // FIXME: If corresponding requirements are added to FloatingPoint
  // add init<U : SignedInteger>(_: Rational<U>) as well as
  // init?<U : SignedInteger>(exactly: Rational<U>).

  /// Returns the hypotenuse of a right-angle triangle with legs (catheti) of
  /// length `x` and `y`, preventing avoidable arithmetic overflow and
  /// underflow. The return value is the square root of the sum of squares of
  /// the arguments.
  ///
  /// - Parameters:
  ///   - x: The length of one leg (cathetus) of a right-angle triangle.
  ///   - y: The length of the other leg (cathetus) of a right-angle triangle.
  static func hypot(_ x: Self, _ y: Self) -> Self

  /// Returns the inverse tangent of `self / other`, using the signs of `self`
  /// and `other` to determine the quadrant of the computed angle.
  ///
  /// If `self == 0 && other == 0`, the return value is still finite.
  ///
  /// - Parameters:
  ///   - other: The divisor by which to divide `self`.
  ///
  /// - SeeAlso: `atan2(_:_:)`
  func inverseTangent(dividingBy other: Self) -> Self

  /// Returns the value of the [error function][dfn] of `self`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/Erf.html
  ///
  /// - SeeAlso: `erf(_:)`
  func error() -> Self

  /// Returns the value of the [complementary error function][dfn] of `self`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/Erfc.html
  ///
  /// - SeeAlso: `erfc(_:)`
  func complementaryError() -> Self

  /// Returns the value of the [gamma function][dfn] of `self`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/GammaFunction.html
  ///
  /// - SeeAlso: `tgamma(_:)`
  func gamma() -> Self

  /// Returns the value of the [logarithmic gamma function][dfn] of `self`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/LogGammaFunction.html
  ///
  /// - SeeAlso: `lgamma(_:)`
  func logarithmicGamma() -> Self
}

extension FloatingPointMath {
  public init(_ value: Rational<Int>) {
    let (whole, fraction) = value.mixed
    self = Self(whole) + Self(fraction.numerator) / Self(fraction.denominator)
  }

  public init(_ value: Rational<Int8>) {
    let (whole, fraction) = value.mixed
    self = Self(whole) + Self(fraction.numerator) / Self(fraction.denominator)
  }

  public init(_ value: Rational<Int16>) {
    let (whole, fraction) = value.mixed
    self = Self(whole) + Self(fraction.numerator) / Self(fraction.denominator)
  }

  public init(_ value: Rational<Int32>) {
    let (whole, fraction) = value.mixed
    self = Self(whole) + Self(fraction.numerator) / Self(fraction.denominator)
  }

  public init(_ value: Rational<Int64>) {
    let (whole, fraction) = value.mixed
    self = Self(whole) + Self(fraction.numerator) / Self(fraction.denominator)
  }

  public static func hypot(_ x: Self, _ y: Self) -> Self {
    var x = abs(x), y = abs(y)
    if x < y {
      swap(&x, &y)
    }
    let ratio = y / x
    return x * .sqrt(1 + ratio * ratio)
  }

  public func inverseTangent(dividingBy other: Self) -> Self {
    let y = self, x = other
    if y.isInfinite {
      if x.isInfinite {
        switch (y.sign, x.sign) {
        case (.minus, .minus): return -.pi * 3 / 4
        case (.plus, .minus): return .pi * 3 / 4
        case (.minus, .plus): return -.pi / 4
        case (.plus, .plus): return .pi / 4
        }
      }
      return y.sign == .minus ? -.pi / 2 : .pi / 2
    }
    if x > 0 {
      return 2 * .atan(y / (.sqrt(x * x + y * y) + x))
    }
    if y != 0 {
      return 2 * .atan((.sqrt(x * x + y * y) - x) / y)
    }
    if x.sign == .minus /* && y == 0 */ {
      return y.sign == .minus ? -.pi : .pi
    }
    /* x.sign == .plus && y == 0 */
    return y.sign == .minus ? -(0 as Self) : 0
  }
}

extension FloatingPointMath {
  /// Returns the inverse tangent of `y / x`, using the signs of `y` and `x` to
  /// determine the quadrant of the computed angle.
  ///
  /// If `x == 0 && y == 0`, the return value is still finite.
  ///
  /// - Parameters:
  ///   - y: The value to divide.
  ///   - x: The divisor by which to divide `y`.
  ///
  /// - SeeAlso: `inverseTangent(dividingBy:)`
  @_transparent // @_inlineable
  public static func atan2(_ y: Self, _ x: Self) -> Self {
    // Note the order of the internal names `y` and `x`, which is deliberate: a
    // minority of programming languages vend functions that reverse the order
    // of the arguments, but all refer to the denominator as `x` and the
    // numerator as `y`.
    return y.inverseTangent(dividingBy: x)
  }

  /// Returns the value of the [error function][dfn] of `x`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/Erf.html
  ///
  /// - SeeAlso: `error()`
  @_transparent // @_inlineable
  public static func erf(_ x: Self) -> Self {
    return x.error()
  }

  /// Returns the value of the [complementary error function][dfn] of `x`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/Erfc.html
  ///
  /// - SeeAlso: `complementaryError()`
  @_transparent // @_inlineable
  public static func erfc(_ x: Self) -> Self {
    return x.complementaryError()
  }

  /// Returns the value of the [gamma function][dfn] of `x`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/GammaFunction.html
  ///
  /// - SeeAlso: `gamma()`
  @_transparent // @_inlineable
  public static func tgamma(_ x: Self) -> Self {
    return x.gamma()
  }

  /// Returns the value of the [logarithmic gamma function][dfn] of `x`.
  ///
  /// [dfn]: http://mathworld.wolfram.com/LogGammaFunction.html
  ///
  /// - SeeAlso: `logarithmicGamma()`
  @_transparent // @_inlineable
  public static func lgamma(_ x: Self) -> Self {
    return x.logarithmicGamma()
  }
}

extension Float : FloatingPointMath {
  @_transparent
  public static var e: Float {
    return Float(0x1.5bf0a8p1)
  }

  @_transparent
  public static var phi: Float {
    return Float(0x1.9e377ap0)
  }

  @_transparent
  public func naturalExponential() -> Float {
    return expf(self)
  }

  @_transparent
  public func binaryExponential() -> Float {
    return exp2f(self)
  }

  @_transparent
  public func commonExponential() -> Float {
    #if os(Linux)
    return exp10f(self)
    #else
    return __exp10f(self)
    #endif
  }

  @_transparent
  public func naturalExponentialMinusOne() -> Float {
    return expm1f(self)
  }

  @_transparent
  public func naturalLogarithm() -> Float {
    return logf(self)
  }

  @_transparent
  public func binaryLogarithm() -> Float {
    return log2f(self)
  }

  @_transparent
  public func commonLogarithm() -> Float {
    return log10f(self)
  }

  @_transparent
  public func naturalLogarithmOnePlus() -> Float {
    return log1pf(self)
  }

  @_transparent
  public func cubeRoot() -> Float {
    return cbrtf(self)
  }

  @_transparent
  public func power(of base: Float) -> Float {
    return powf(base, self)
  }

  @_transparent
  public func sine() -> Float {
    return sinf(self)
  }

  @_transparent
  public func cosine() -> Float {
    return cosf(self)
  }

  @_transparent
  public func tangent() -> Float {
    return tanf(self)
  }

  @_transparent
  public func inverseSine() -> Float {
    return asinf(self)
  }

  @_transparent
  public func inverseCosine() -> Float {
    return acosf(self)
  }

  @_transparent
  public func inverseTangent() -> Float {
    return atanf(self)
  }

  @_transparent
  public func hyperbolicSine() -> Float {
    return sinhf(self)
  }

  @_transparent
  public func hyperbolicCosine() -> Float {
    return coshf(self)
  }

  @_transparent
  public func hyperbolicTangent() -> Float {
    return tanhf(self)
  }

  @_transparent
  public func inverseHyperbolicSine() -> Float {
    return asinhf(self)
  }

  @_transparent
  public func inverseHyperbolicCosine() -> Float {
    return acoshf(self)
  }

  @_transparent
  public func inverseHyperbolicTangent() -> Float {
    return atanhf(self)
  }

  @_transparent
  public static func hypot(_ x: Float, _ y: Float) -> Float {
    return hypotf(x, y)
  }

  @_transparent
  public func inverseTangent(dividingBy other: Float) -> Float {
    return atan2f(self, other)
  }

  @_transparent
  public func error() -> Float {
    return erff(self)
  }

  @_transparent
  public func complementaryError() -> Float {
    return erfcf(self)
  }

  @_transparent
  public func gamma() -> Float {
    return tgammaf(self)
  }

  @_transparent
  public func logarithmicGamma() -> Float {
    return lgammaf(self)
  }
}

extension Double : FloatingPointMath {
  @_transparent
  public static var e: Double {
    return Double(0x1.5bf0a8b145769p1)
  }

  @_transparent
  public static var phi: Double {
    return Double(0x1.9e3779b97f4a8p0)
  }

  @_transparent
  public func naturalExponential() -> Double {
    #if os(Linux)
    return Glibc.exp(self)
    #else
    return Darwin.exp(self)
    #endif
  }

  @_transparent
  public func binaryExponential() -> Double {
    #if os(Linux)
    return Glibc.exp2(self)
    #else
    return Darwin.exp2(self)
    #endif
  }

  @_transparent
  public func commonExponential() -> Double {
    #if os(Linux)
    return Glibc.exp10(self)
    #else
    return __exp10(self)
    #endif
  }

  @_transparent
  public func naturalExponentialMinusOne() -> Double {
    #if os(Linux)
    return Glibc.expm1(self)
    #else
    return Darwin.expm1(self)
    #endif
  }

  @_transparent
  public func naturalLogarithm() -> Double {
    #if os(Linux)
    return Glibc.log(self)
    #else
    return Darwin.log(self)
    #endif
  }

  @_transparent
  public func binaryLogarithm() -> Double {
    #if os(Linux)
    return Glibc.log2(self)
    #else
    return Darwin.log2(self)
    #endif
  }

  @_transparent
  public func commonLogarithm() -> Double {
    #if os(Linux)
    return Glibc.log10(self)
    #else
    return Darwin.log10(self)
    #endif
  }

  @_transparent
  public func naturalLogarithmOnePlus() -> Double {
    #if os(Linux)
    return Glibc.log1p(self)
    #else
    return Darwin.log1p(self)
    #endif
  }

  @_transparent
  public func cubeRoot() -> Double {
    #if os(Linux)
    return Glibc.cbrt(self)
    #else
    return Darwin.cbrt(self)
    #endif
  }

  @_transparent
  public func power(of base: Double) -> Double {
    #if os(Linux)
    return Glibc.pow(base, self)
    #else
    return Darwin.pow(base, self)
    #endif
  }

  @_transparent
  public func sine() -> Double {
    #if os(Linux)
    return Glibc.sin(self)
    #else
    return Darwin.sin(self)
    #endif
  }

  @_transparent
  public func cosine() -> Double {
    #if os(Linux)
    return Glibc.cos(self)
    #else
    return Darwin.cos(self)
    #endif
  }

  @_transparent
  public func tangent() -> Double {
    #if os(Linux)
    return Glibc.tan(self)
    #else
    return Darwin.tan(self)
    #endif
  }

  @_transparent
  public func inverseSine() -> Double {
    #if os(Linux)
    return Glibc.asin(self)
    #else
    return Darwin.asin(self)
    #endif
  }

  @_transparent
  public func inverseCosine() -> Double {
    #if os(Linux)
    return Glibc.acos(self)
    #else
    return Darwin.acos(self)
    #endif
  }

  @_transparent
  public func inverseTangent() -> Double {
    #if os(Linux)
    return Glibc.atan(self)
    #else
    return Darwin.atan(self)
    #endif
  }

  @_transparent
  public func hyperbolicSine() -> Double {
    #if os(Linux)
    return Glibc.sinh(self)
    #else
    return Darwin.sinh(self)
    #endif
  }

  @_transparent
  public func hyperbolicCosine() -> Double {
    #if os(Linux)
    return Glibc.cosh(self)
    #else
    return Darwin.cosh(self)
    #endif
  }

  @_transparent
  public func hyperbolicTangent() -> Double {
    #if os(Linux)
    return Glibc.tanh(self)
    #else
    return Darwin.tanh(self)
    #endif
  }

  @_transparent
  public func inverseHyperbolicSine() -> Double {
    #if os(Linux)
    return Glibc.asinh(self)
    #else
    return Darwin.asinh(self)
    #endif
  }

  @_transparent
  public func inverseHyperbolicCosine() -> Double {
    #if os(Linux)
    return Glibc.acosh(self)
    #else
    return Darwin.acosh(self)
    #endif
  }

  @_transparent
  public func inverseHyperbolicTangent() -> Double {
    #if os(Linux)
    return Glibc.atanh(self)
    #else
    return Darwin.atanh(self)
    #endif
  }

  @_transparent
  public static func hypot(_ x: Double, _ y: Double) -> Double {
    #if os(Linux)
    return Glibc.hypot(x, y)
    #else
    return Darwin.hypot(x, y)
    #endif
  }

  @_transparent
  public func inverseTangent(dividingBy other: Double) -> Double {
    #if os(Linux)
    return Glibc.atan2(self, other)
    #else
    return Darwin.atan2(self, other)
    #endif
  }

  @_transparent
  public func error() -> Double {
    #if os(Linux)
    return Glibc.erf(self)
    #else
    return Darwin.erf(self)
    #endif
  }

  @_transparent
  public func complementaryError() -> Double {
    #if os(Linux)
    return Glibc.erfc(self)
    #else
    return Darwin.erfc(self)
    #endif
  }

  @_transparent
  public func gamma() -> Double {
    #if os(Linux)
    return Glibc.tgamma(self)
    #else
    return Darwin.tgamma(self)
    #endif
  }

  @_transparent
  public func logarithmicGamma() -> Double {
    #if os(Linux)
    return Glibc.lgamma(self)
    #else
    return Darwin.lgamma(self)
    #endif
  }
}
