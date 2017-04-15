//
//  Rational.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

/// A type to represent a rational value in canonical form.
// @_fixed_layout
public struct Rational<T : _SignedInteger> where T.Magnitude : _UnsignedInteger {
  /// The numerator of the rational value.
  public var numerator: T

  /// The denominator of the rational value.
  public var denominator: T

  /// Positive infinity.
  ///
  /// Infinity compares greater than all finite numbers and equal to other
  /// (positive) infinite values.
  public static var infinity: Rational {
    return Rational(numerator: 1, denominator: 0)
  }

  /// A quiet NaN ("not a number").
  ///
  /// A NaN compares not equal, not greater than, and not less than every value,
  /// including itself. Passing a NaN to an operation generally results in NaN.
  public static var nan: Rational {
    return Rational(numerator: 0, denominator: 0)
  }
}

public typealias RationalSign = FloatingPointSign

extension Rational {
  /// A Boolean value indicating whether the instance's representation is in
  /// canonical form.
  @_transparent // @_inlineable
  public var isCanonical: Bool {
    if denominator > 0 { return isIrreducible }
    return denominator == 0 &&
      (numerator == -1 || numerator == 0 || numerator == 1)
  }

  /// A Boolean value indicating whether the instance is finite.
  ///
  /// All values other than NaN and infinity are considered finite.
  @_transparent // @_inlineable
  public var isFinite: Bool {
    return denominator != 0
  }

  /// A Boolean value indicating whether the instance is infinite.
  ///
  /// Note that `isFinite` and `isInfinite` do not form a dichotomy because NaN
  /// is neither finite nor infinite.
  @_transparent // @_inlineable
  public var isInfinite: Bool {
    return denominator == 0 && numerator != 0
  }

  /// A Boolean value indicating whether the instance is irreducible (that is,
  /// reduced to lowest terms).
  @_transparent // @_inlineable
  public var isIrreducible: Bool {
    return T.gcd(numerator, denominator) == 1
  }

  /// A Boolean value indicating whether the instance is NaN ("not a number").
  ///
  /// Because NaN is not equal to any value, including NaN, use this property
  /// instead of the equal-to operator (`==`) or not-equal-to operator (`!=`) to
  /// test whether a value is or is not NaN.
  @_transparent // @_inlineable
  public var isNaN: Bool {
    return denominator == 0 && numerator == 0
  }

  /// A Boolean value indicating whether the instance is equal to zero.
  @_transparent // @_inlineable
  public var isZero: Bool {
    return denominator != 0 && numerator == 0
  }

  // TODO: `magnitude`

  /// The sign of this value.
  @_transparent // @_inlineable
  public var sign: RationalSign {
    return (denominator < 0) == (numerator < 0) ? .plus : .minus
  }

  /// The canonicalized representation of this value.
  @_transparent // @_inlineable
  internal func _canonicalized() -> Rational {
    let gcd = T.gcd(numerator, denominator)
    guard gcd != 0 else { return self }
    let divisor = denominator < 0 ? -gcd : gcd
    return Rational(
      numerator: numerator / divisor,
      denominator: denominator / divisor
    )
  }

  /// The reciprocal (multiplicative inverse) of this value.
  @_transparent // @_inlineable
  public func reciprocal() -> Rational {
    return (numerator < 0) ?
      Rational(numerator: -denominator, denominator: -numerator) :
      Rational(numerator: denominator, denominator: numerator)
  }
}

// TODO: `init<U : SignedInteger>(_: Rational<U>) where U.Magnitude : UnsignedInteger` and related

extension Rational : ExpressibleByIntegerLiteral {
  @_transparent // @_inlineable
  public init(integerLiteral value: T) {
    self.numerator = value
    self.denominator = 1
  }
}

extension Rational : CustomStringConvertible {
  @_transparent // @_inlineable
  public var description: String {
    if numerator == 0 { return denominator == 0 ? "nan" : "0" }
    if denominator == 0 { return numerator < 0 ? "-inf" : "inf" }
    return denominator == 1 ? "\(numerator)" : "\(numerator)/\(denominator)"
  }
}

extension Rational : Equatable {
  @_transparent // @_inlineable
  public static func == (lhs: Rational, rhs: Rational) -> Bool {
    precondition(lhs.isCanonical && rhs.isCanonical)
    if lhs.isNaN || rhs.isNaN { return false }
    return lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator
  }
}

// TODO: `extension Rational : Comparable`

extension Rational : Hashable {
  @_transparent // @_inlineable
  public var hashValue: Int {
    precondition(isCanonical)
    return _fnv1a(numerator, denominator)
  }
}
