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

public protocol FloatingPointMath : Math, FloatingPoint /*, Hashable */ {
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
  public static func hypot(_ x: Self, _ y: Self) -> Self {
    var x = abs(x), y = abs(y)
    if x < y {
      swap(&x, &y)
    }
    let ratio = y / x
    return x * sqrt(1 + ratio * ratio)
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
      return 2 * Self.atan(y / (sqrt(x * x + y * y) + x))
    }
    if y != 0 {
      return 2 * Self.atan((sqrt(x * x + y * y) - x) / y)
    }
    if x.sign == .minus /* && y == 0 */ {
      return y.sign == .minus ? -.pi : .pi
    }
    /* x.sign == .plus && y == 0 */
    return y.sign == .minus ? -(0 as Self) : 0
  }
}

extension FloatingPointMath {
  @_transparent // @_inlineable
  public static func atan2(_ y: Self, _ x: Self) -> Self {
    return y.inverseTangent(dividingBy: x)
  }

  @_transparent // @_inlineable
  public static func erf(_ a: Self) -> Self {
    return a.error()
  }

  @_transparent // @_inlineable
  public static func erfc(_ a: Self) -> Self {
    return a.complementaryError()
  }

  @_transparent // @_inlineable
  public static func tgamma(_ a: Self) -> Self {
    return a.gamma()
  }

  @_transparent // @_inlineable
  public static func lgamma(_ a: Self) -> Self {
    return a.logarithmicGamma()
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
  public func naturalLogarithmOfOnePlus() -> Float {
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
    return exp(self)
  }

  @_transparent
  public func binaryExponential() -> Double {
    return exp2(self)
  }

  @_transparent
  public func commonExponential() -> Double {
    #if os(Linux)
    return exp10(self)
    #else
    return __exp10(self)
    #endif
  }

  @_transparent
  public func naturalExponentialMinusOne() -> Double {
    return expm1(self)
  }

  @_transparent
  public func naturalLogarithm() -> Double {
    return log(self)
  }

  @_transparent
  public func binaryLogarithm() -> Double {
    return log2(self)
  }

  @_transparent
  public func commonLogarithm() -> Double {
    return log10(self)
  }

  @_transparent
  public func naturalLogarithmOfOnePlus() -> Double {
    return log1p(self)
  }

  @_transparent
  public func cubeRoot() -> Double {
    return cbrt(self)
  }

  @_transparent
  public func power(of base: Double) -> Double {
    return pow(base, self)
  }

  @_transparent
  public func sine() -> Double {
    return sin(self)
  }

  @_transparent
  public func cosine() -> Double {
    return cos(self)
  }

  @_transparent
  public func tangent() -> Double {
    return tan(self)
  }

  @_transparent
  public func inverseSine() -> Double {
    return asin(self)
  }

  @_transparent
  public func inverseCosine() -> Double {
    return acos(self)
  }

  @_transparent
  public func inverseTangent() -> Double {
    return atan(self)
  }

  @_transparent
  public func hyperbolicSine() -> Double {
    return sinh(self)
  }

  @_transparent
  public func hyperbolicCosine() -> Double {
    return cosh(self)
  }

  @_transparent
  public func hyperbolicTangent() -> Double {
    return tanh(self)
  }

  @_transparent
  public func inverseHyperbolicSine() -> Double {
    return asinh(self)
  }

  @_transparent
  public func inverseHyperbolicCosine() -> Double {
    return acosh(self)
  }

  @_transparent
  public func inverseHyperbolicTangent() -> Double {
    return atanh(self)
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
    return atan2(self, other)
  }

  @_transparent
  public func error() -> Double {
    return erf(self)
  }

  @_transparent
  public func complementaryError() -> Double {
    return erfc(self)
  }

  @_transparent
  public func gamma() -> Double {
    return tgamma(self)
  }

  @_transparent
  public func logarithmicGamma() -> Double {
    return lgamma(self)
  }
}
