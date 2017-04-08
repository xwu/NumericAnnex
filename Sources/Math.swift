//
//  Math.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 3/31/17.
//

public protocol Math
  : Equatable, ExpressibleByIntegerLiteral/*, SignedNumeric */ {

  // ---------------------------------------------------------------------------
  // FIXME: Remove the following three requirements after Numeric conformance
  static func + (_: Self, _: Self) -> Self
  static func - (_: Self, _: Self) -> Self
  static func * (_: Self, _: Self) -> Self
  // ---------------------------------------------------------------------------

  /// Returns the quotient obtained by dividing the first value by the second,
  /// rounded to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value by which to divide `lhs`.
  static func / (lhs: Self, rhs: Self) -> Self

  /// Returns the natural exponential of the value, rounded to a representable
  /// value.
  ///
  /// The natural exponential of a value `x` is _e_ (2.7182818...) raised to the
  /// power of `x`.
  ///
  /// - SeeAlso: `exp(_:)`
  func naturalExponential() -> Self

  /// Returns the binary exponential of the value, rounded to a representable
  /// value.
  ///
  /// The binary exponential of a value `x` is 2 raised to the power of `x`.
  ///
  /// - SeeAlso: `exp2(_:)`
  func binaryExponential() -> Self

  /// Returns the common exponential of the value, rounded to a representable
  /// value.
  ///
  /// The common exponential of a value `x` is 10 raised to the power of `x`.
  ///
  /// - SeeAlso: `exp10(_:)`
  func commonExponential() -> Self

  /// Returns the natural exponential of the value, minus one, rounded to a
  /// representable value.
  ///
  /// The natural exponential of a value `x` is _e_ (2.7182818...) raised to the
  /// power of `x`.
  ///
  /// This function is more accurate than `x.naturalExponential() - 1` for
  /// values of `x` close to zero.
  ///
  /// - SeeAlso: `expm1(_:)`
  func naturalExponentialMinusOne() -> Self

  /// Returns the natural (base _e_) logarithm of the value, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `log(_:)`
  func naturalLogarithm() -> Self

  /// Returns the binary (base 2) logarithm of the value, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `log2(_:)`
  func binaryLogarithm() -> Self

  /// Returns the common (base 10) logarithm of the value, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `log10(_:)`
  func commonLogarithm() -> Self

  /// Returns the natural (base _e_) logarithm of one plus the value, rounded
  /// to a representable value.
  ///
  /// - SeeAlso: `log1p(_:)`
  func naturalLogarithmOfOnePlus() -> Self

  /// Returns the square root of the value, rounded to a representable value.
  ///
  /// - SeeAlso: `sqrt(_:)`
  func squareRoot() -> Self

  /// Returns the cube root of the value, rounded to a representable value.
  ///
  /// - SeeAlso: `cbrt(_:)`
  func cubeRoot() -> Self

  /// Returns the result of raising `base` to the power of the value, rounded to
  /// a representable value.
  ///
  /// - Note: The argument is the _base_ and the receiver is the _exponent_.
  ///
  /// - Parameters:
  ///   - base: The base.
  ///
  /// - SeeAlso: `pow(_:_:)`
  func power(of base: Self) -> Self

  /// Returns the sine of the value (given in radians), rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `sin(_:)`
  func sine() -> Self

  /// Returns the cosine of the value (given in radians), rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `cos(_:)`
  func cosine() -> Self

  /// Returns the tangent of the value (given in radians), rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `tan(_:)`
  func tangent() -> Self

  /// Returns the principal value of the inverse sine of the value, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `asin(_:)`
  func inverseSine() -> Self

  /// Returns the principal value of the inverse cosine of the value, rounded to
  /// a representable value.
  ///
  /// - SeeAlso: `acos(_:)`
  func inverseCosine() -> Self

  /// Returns the principal value of the inverse tangent of the value, rounded
  /// to a representable value.
  ///
  /// - SeeAlso: `atan(_:)`
  func inverseTangent() -> Self

  /// Returns the hyperbolic sine of the value, rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `sinh(_:)`
  func hyperbolicSine() -> Self

  /// Returns the hyperbolic cosine of the value, rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `cosh(_:)`
  func hyperbolicCosine() -> Self

  /// Returns the hyperbolic tangent of the value, rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `tanh(_:)`
  func hyperbolicTangent() -> Self

  /// Returns the principal value of the inverse hyperbolic sine of the value,
  /// rounded to a representable value.
  ///
  /// - SeeAlso: `asinh(_:)`
  func inverseHyperbolicSine() -> Self

  /// Returns the principal value of the inverse hyperbolic cosine of the value,
  /// rounded to a representable value.
  ///
  /// - SeeAlso: `acosh(_:)`
  func inverseHyperbolicCosine() -> Self

  /// Returns the principal value of the inverse hyperbolic tangent of the
  /// value, rounded to a representable value.
  ///
  /// - SeeAlso: `atanh(_:)`
  func inverseHyperbolicTangent() -> Self
}

extension Math {
  public func binaryExponential() -> Self {
    return Self.exp(self * Self.log(2 as Self))
  }

  public func commonExponential() -> Self {
    return Self.exp(self * Self.log(10 as Self))
  }

  public func naturalExponentialMinusOne() -> Self {
    return Self.exp(self) - (1 as Self)
  }

  public func binaryLogarithm() -> Self {
    return Self.log(self) / Self.log(2 as Self)
  }

  public func commonLogarithm() -> Self {
    return Self.log(self) / Self.log(10 as Self)
  }

  public func naturalLogarithmOfOnePlus() -> Self {
    return Self.log(self + (1 as Self))
  }

  public func cubeRoot() -> Self {
    return Self.pow(self, 1 / 3 as Self)
  }

  public func tangent() -> Self {
    return sine() / cosine()
  }

  public func hyperbolicTangent() -> Self {
    return hyperbolicSine() / hyperbolicCosine()
  }
}

extension Math {
  @_transparent // @_inlineable
  public static func exp(_ x: Self) -> Self {
    return x.naturalExponential()
  }

  @_transparent // @_inlineable
  public static func exp2(_ x: Self) -> Self {
    return x.binaryExponential()
  }

  @_transparent // @_inlineable
  public static func exp10(_ x: Self) -> Self {
    return x.commonExponential()
  }

  @_transparent // @_inlineable
  public static func expm1(_ x: Self) -> Self {
    return x.naturalExponentialMinusOne()
  }

  @_transparent // @_inlineable
  public static func log(_ x: Self) -> Self {
    return x.naturalLogarithm()
  }

  @_transparent // @_inlineable
  public static func log2(_ x: Self) -> Self {
    return x.binaryLogarithm()
  }

  @_transparent // @_inlineable
  public static func log10(_ x: Self) -> Self {
    return x.commonLogarithm()
  }

  @_transparent // @_inlineable
  public static func log1p(_ x: Self) -> Self {
    return x.naturalLogarithmOfOnePlus()
  }

  @_transparent // @_inlineable
  public static func sqrt(_ x: Self) -> Self {
    return x.squareRoot()
  }

  @_transparent // @_inlineable
  public static func cbrt(_ x: Self) -> Self {
    return x.cubeRoot()
  }

  @_transparent // @_inlineable
  public static func pow(_ base: Self, _ exponent: Self) -> Self {
    return exponent.power(of: base)
  }

  @_transparent // @_inlineable
  public static func sin(_ x: Self) -> Self {
    return x.sine()
  }

  @_transparent // @_inlineable
  public static func cos(_ x: Self) -> Self {
    return x.cosine()
  }

  @_transparent // @_inlineable
  public static func tan(_ x: Self) -> Self {
    return x.tangent()
  }

  @_transparent // @_inlineable
  public static func asin(_ x: Self) -> Self {
    return x.inverseSine()
  }

  @_transparent // @_inlineable
  public static func acos(_ x: Self) -> Self {
    return x.inverseCosine()
  }

  @_transparent // @_inlineable
  public static func atan(_ x: Self) -> Self {
    return x.inverseTangent()
  }

  @_transparent // @_inlineable
  public static func sinh(_ x: Self) -> Self {
    return x.hyperbolicSine()
  }

  @_transparent // @_inlineable
  public static func cosh(_ x: Self) -> Self {
    return x.hyperbolicCosine()
  }

  @_transparent // @_inlineable
  public static func tanh(_ x: Self) -> Self {
    return x.hyperbolicTangent()
  }

  @_transparent // @_inlineable
  public static func asinh(_ x: Self) -> Self {
    return x.inverseHyperbolicSine()
  }

  @_transparent // @_inlineable
  public static func acosh(_ x: Self) -> Self {
    return x.inverseHyperbolicCosine()
  }

  @_transparent // @_inlineable
  public static func atanh(_ x: Self) -> Self {
    return x.inverseHyperbolicTangent()
  }
}
