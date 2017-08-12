//
//  Math.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 3/31/17.
//

/// A signed numeric type that supports elementary functions.
///
/// The `Math` protocol provides a suitable basis for writing functions that
/// work on any real or complex floating-point type that supports the required
/// functions.
public protocol Math : SignedNumeric {
  /// The mathematical constant pi (_π_).
  ///
  /// This value should be rounded toward zero to keep user computations with
  /// angles from inadvertently ending up in the wrong quadrant. A type that
  /// conforms to the `Math` protocol provides the value for `pi` at its best
  /// possible precision.
  static var pi: Self { get }

  /// The mathematical constant _e_, or Euler's number.
  static var e: Self { get }

  /// The mathematical constant phi (_φ_), or golden ratio.
  static var phi: Self { get }

  /// Returns the quotient obtained by dividing the first value by the second,
  /// rounded to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value by which to divide `lhs`.
  static func / (lhs: Self, rhs: Self) -> Self

  /// Divides the left-hand side by the right-hand side and stores the quotient
  /// in the left-hand side, rounded to a representable value.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value by which to divide `lhs`.
  static func /= (lhs: inout Self, rhs: Self)

  /// Returns the result of raising `base` to the power of `exponent`, rounded
  /// to a representable value.
  ///
  /// - Parameters:
  ///   - base: The base to be raised to the power of `exponent`.
  ///   - exponent: The exponent by which to raise `base`.
  static func pow(_ base: Self, _ exponent: Self) -> Self

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

  /// Returns the result of subtracting one from the natural exponential of the
  /// value, rounded to a representable value.
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

  /// Returns the natural (base _e_) logarithm of the result of adding one to
  /// the value, rounded to a representable value.
  ///
  /// - SeeAlso: `log1p(_:)`
  func naturalLogarithmOnePlus() -> Self

  /// Returns the square root of the value, rounded to a representable value.
  ///
  /// - SeeAlso: `sqrt(_:)`
  func squareRoot() -> Self

  /// Returns the cube root of the value, rounded to a representable value.
  ///
  /// - SeeAlso: `cbrt(_:)`
  func cubeRoot() -> Self

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
  /// The mathematical constant _e_, or Euler's number (default implementation).
  public static var e: Self {
    return Self.exp(1 as Self)
  }

  /// The mathematical constant phi (_φ_), or golden ratio (default
  /// implementation).
  public static var phi: Self {
    return ((1 as Self) + Self.sqrt(5 as Self)) / (2 as Self)
  }

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

  public func naturalLogarithmOnePlus() -> Self {
    return Self.log(self + (1 as Self))
  }

  public func tangent() -> Self {
    return sine() / cosine()
  }

  public func hyperbolicTangent() -> Self {
    return hyperbolicSine() / hyperbolicCosine()
  }
}

extension Math {
  /// Returns the natural exponential of `x`, rounded to a representable value.
  ///
  /// The natural exponential of a value `x` is _e_ (2.7182818...) raised to the
  /// power of `x`.
  ///
  /// - SeeAlso: `naturalExponential()`
  @_transparent // @_inlineable
  public static func exp(_ x: Self) -> Self {
    return x.naturalExponential()
  }

  /// Returns the binary exponential of `x`, rounded to a representable value.
  ///
  /// The binary exponential of a value `x` is 2 raised to the power of `x`.
  ///
  /// - SeeAlso: `binaryExponential()`
  @_transparent // @_inlineable
  public static func exp2(_ x: Self) -> Self {
    return x.binaryExponential()
  }

  /// Returns the common exponential of `x`, rounded to a representable value.
  ///
  /// The common exponential of a value `x` is 10 raised to the power of `x`.
  ///
  /// - SeeAlso: `commonExponential()`
  @_transparent // @_inlineable
  public static func exp10(_ x: Self) -> Self {
    return x.commonExponential()
  }

  /// Returns the result of subtracting one from the natural exponential of `x`,
  /// rounded to a representable value.
  ///
  /// The natural exponential of a value `x` is _e_ (2.7182818...) raised to the
  /// power of `x`.
  ///
  /// This function is more accurate than `.exp(x) - 1` for values of `x` close
  /// to zero.
  ///
  /// - SeeAlso: `naturalExponentialMinusOne()`
  @_transparent // @_inlineable
  public static func expm1(_ x: Self) -> Self {
    return x.naturalExponentialMinusOne()
  }

  /// Returns the natural (base _e_) logarithm of `x`, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `naturalLogarithm()`
  @_transparent // @_inlineable
  public static func log(_ x: Self) -> Self {
    return x.naturalLogarithm()
  }

  /// Returns the binary (base 2) logarithm of `x`, rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `binaryLogarithm()`
  @_transparent // @_inlineable
  public static func log2(_ x: Self) -> Self {
    return x.binaryLogarithm()
  }

  /// Returns the common (base 10) logarithm of `x`, rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `commonLogarithm()`
  @_transparent // @_inlineable
  public static func log10(_ x: Self) -> Self {
    return x.commonLogarithm()
  }

  /// Returns the natural (base _e_) logarithm of the result of adding one to
  /// `x`, rounded to a representable value.
  ///
  /// - SeeAlso: `naturalLogarithmOnePlus()`
  @_transparent // @_inlineable
  public static func log1p(_ x: Self) -> Self {
    return x.naturalLogarithmOnePlus()
  }

  /// Returns the square root of `x`, rounded to a representable value.
  ///
  /// - SeeAlso: `squareRoot()`
  @_transparent // @_inlineable
  public static func sqrt(_ x: Self) -> Self {
    return x.squareRoot()
  }

  /// Returns the cube root of `x`, rounded to a representable value.
  ///
  /// - SeeAlso: `cubeRoot()`
  @_transparent // @_inlineable
  public static func cbrt(_ x: Self) -> Self {
    return x.cubeRoot()
  }

  /// Returns the sine of `x` (given in radians), rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `sine()`
  @_transparent // @_inlineable
  public static func sin(_ x: Self) -> Self {
    return x.sine()
  }

  /// Returns the cosine of `x` (given in radians), rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `cosine()`
  @_transparent // @_inlineable
  public static func cos(_ x: Self) -> Self {
    return x.cosine()
  }

  /// Returns the tangent of `x` (given in radians), rounded to a representable
  /// value.
  ///
  /// - SeeAlso: `tangent()`
  @_transparent // @_inlineable
  public static func tan(_ x: Self) -> Self {
    return x.tangent()
  }

  /// Returns the principal value of the inverse sine of `x`, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `inverseSine()`
  @_transparent // @_inlineable
  public static func asin(_ x: Self) -> Self {
    return x.inverseSine()
  }

  /// Returns the principal value of the inverse cosine of `x`, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `inverseCosine()`
  @_transparent // @_inlineable
  public static func acos(_ x: Self) -> Self {
    return x.inverseCosine()
  }

  /// Returns the principal value of the inverse tangent of `x`, rounded to a
  /// representable value.
  ///
  /// - SeeAlso: `inverseTangent()`
  @_transparent // @_inlineable
  public static func atan(_ x: Self) -> Self {
    return x.inverseTangent()
  }

  /// Returns the hyperbolic sine of `x`, rounded to a representable value.
  ///
  /// - SeeAlso: `hyperbolicSine()`
  @_transparent // @_inlineable
  public static func sinh(_ x: Self) -> Self {
    return x.hyperbolicSine()
  }

  /// Returns the hyperbolic cosine of `x`, rounded to a representable value.
  ///
  /// - SeeAlso: `hyperbolicCosine()`
  @_transparent // @_inlineable
  public static func cosh(_ x: Self) -> Self {
    return x.hyperbolicCosine()
  }

  /// Returns the hyperbolic tangent of `x`, rounded to a representable value.
  ///
  /// - SeeAlso: `hyperbolicTangent()`
  @_transparent // @_inlineable
  public static func tanh(_ x: Self) -> Self {
    return x.hyperbolicTangent()
  }

  /// Returns the principal value of the inverse hyperbolic sine of `x`, rounded
  /// to a representable value.
  ///
  /// - SeeAlso: `inverseHyperbolicSine()`
  @_transparent // @_inlineable
  public static func asinh(_ x: Self) -> Self {
    return x.inverseHyperbolicSine()
  }

  /// Returns the principal value of the inverse hyperbolic cosine of `x`,
  /// rounded to a representable value.
  ///
  /// - SeeAlso: `inverseHyperbolicCosine()`
  @_transparent // @_inlineable
  public static func acosh(_ x: Self) -> Self {
    return x.inverseHyperbolicCosine()
  }

  /// Returns the principal value of the inverse hyperbolic tangent of `x`,
  /// rounded to a representable value.
  ///
  /// - SeeAlso: `inverseHyperbolicTangent()`
  @_transparent // @_inlineable
  public static func atanh(_ x: Self) -> Self {
    return x.inverseHyperbolicTangent()
  }
}
