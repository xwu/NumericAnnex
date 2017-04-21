//
//  Rational.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

/// A type to represent a rational value in canonical form.
// @_fixed_layout
public struct Rational<
  T : SignedInteger & _ExpressibleByBuiltinIntegerLiteral
> where T.Magnitude : UnsignedInteger, T.Magnitude.Magnitude == T.Magnitude {
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
    if denominator > 0 {
      return T.Magnitude.gcd(numerator.magnitude, denominator.magnitude) == 1
    }
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

  /// A Boolean value indicating whether the instance is NaN ("not a number").
  ///
  /// Because NaN is not equal to any value, including NaN, use this property
  /// instead of the equal-to operator (`==`) or not-equal-to operator (`!=`) to
  /// test whether a value is or is not NaN.
  @_transparent // @_inlineable
  public var isNaN: Bool {
    return denominator == 0 && numerator == 0
  }

  /// A Boolean value indicating whether the instance is a proper fraction.
  ///
  /// A fraction `p / q` is proper iff `p > 0`, `q > 0`, and `p < q`.
  @_transparent // @_inlineable
  public var isProperFraction: Bool {
    return numerator > 0 && denominator > 0 && numerator < denominator
  }

  /// A Boolean value indicating whether the instance is equal to zero.
  @_transparent // @_inlineable
  public var isZero: Bool {
    return denominator != 0 && numerator == 0
  }

  /// The magnitude (absolute value) of this value.
  @_transparent // @_inlineable
  public var magnitude: Rational {
    return sign == .minus ? -self : self
  }

  /// The sign of this value.
  @_transparent // @_inlineable
  public var sign: RationalSign {
    return (denominator < 0) == (numerator < 0) ? .plus : .minus
  }

  /// The canonicalized representation of this value.
  @_transparent // @_inlineable
  internal func _canonicalized() -> Rational {
    let nm = numerator.magnitude, dm = denominator.magnitude

    // Note that if `T` is a signed fixed-width integer type, `gcd(nm, dm)`
    // could be equal to `-T.min`, which is not representable as a `T`. This is
    // why the following arithmetic is performed with values of type
    // `T.Magnitude`.
    let gcd = T.Magnitude.gcd(nm, dm)
    guard gcd != 0 else { return self }

    let n = nm / gcd
    let d = dm / gcd
    if sign == .plus {
      return Rational(numerator: T(n), denominator: T(d))
    }
    return Rational(numerator: -T(n), denominator: T(d))
  }

  /// The reciprocal (multiplicative inverse) of this value.
  @_transparent // @_inlineable
  public func reciprocal() -> Rational {
    return (numerator < 0) ?
      Rational(numerator: -denominator, denominator: -numerator) :
      Rational(numerator: denominator, denominator: numerator)
  }
}

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
    if lhs.denominator == 0 {
      if lhs.numerator == 0 { return false }
      return rhs.denominator == 0 && rhs.numerator != 0
        && (lhs.numerator < 0) == (rhs.numerator < 0)
    }
    if rhs.denominator == 0 { return false }

    switch (lhs.sign, rhs.sign) {
    case (.plus, .minus):
      fallthrough
    case (.minus, .plus):
      return false
    case (.plus, .plus):
      fallthrough
    case (.minus, .minus):
      let ldm = lhs.denominator.magnitude
      let rdm = rhs.denominator.magnitude
      if ldm == rdm {
        return lhs.numerator.magnitude == rhs.numerator.magnitude
      }
      let gcd = T.Magnitude.gcd(ldm, rdm)
      let a = ldm / gcd
      let b = rdm / gcd
      return a * lhs.numerator.magnitude == b * rhs.numerator.magnitude
    }
  }
}

extension Rational : Comparable {
  @_transparent // @_inlineable
  public static func < (lhs: Rational, rhs: Rational) -> Bool {
    if lhs.isNaN || rhs.isNaN { return false }
    if rhs == -.infinity { return false }
    if lhs == -.infinity { return true }

    func isMagnitudeLessThan() -> Bool {
      let ldm = lhs.denominator.magnitude
      let rdm = rhs.denominator.magnitude
      let gcd = T.Magnitude.gcd(ldm, rdm)
      let a = ldm / gcd
      let b = rdm / gcd
      return a * lhs.numerator.magnitude < b * rhs.numerator.magnitude
    }

    switch (lhs.sign, rhs.sign) {
    case (.plus, .minus):
      return false
    case (.minus, .plus):
      return true
    case (.plus, .plus):
      return isMagnitudeLessThan()
    case (.minus, .minus):
      return !isMagnitudeLessThan()
    }
  }
}

extension Rational where T.Magnitude : FixedWidthInteger {
  @_transparent // @_inlineable
  public static func < (lhs: Rational, rhs: Rational) -> Bool {
    if lhs.isNaN || rhs.isNaN { return false }
    if rhs == -.infinity { return false }
    if lhs == -.infinity { return true }

    func isMagnitudeLessThan() -> Bool {
      let ldm = lhs.denominator.magnitude
      let rdm = rhs.denominator.magnitude
      let gcd = T.Magnitude.gcd(ldm, rdm)
      let a = ldm / gcd
      let b = rdm / gcd
      // Use full-width multiplication to avoid trapping on overflow.
      let c = a.multipliedFullWidth(by: lhs.numerator.magnitude)
      let d = b.multipliedFullWidth(by: rhs.numerator.magnitude)
      return c.high == d.high ? c.low < d.low : c.high < d.high
    }

    switch (lhs.sign, rhs.sign) {
    case (.plus, .plus):
      return isMagnitudeLessThan()
    case (.plus, .minus):
      return false
    case (.minus, .plus):
      return true
    case (.minus, .minus):
      return !isMagnitudeLessThan()
    }
  }
}

extension Rational : Hashable {
  @_transparent // @_inlineable
  public var hashValue: Int {
    let t = self._canonicalized()
    return _fnv1a(t.numerator, t.denominator)
  }
}
