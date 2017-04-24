//
//  Rational.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

/// A type to represent a rational value.
///
/// - Note: `Ratio` is a type alias for `Rational<Int>`.
///
/// Create new instances of `Rational<T>` by using integer literals and the
/// division (`/`) operator. For example:
///
/// ```swift
/// let x = 1 / 3 as Ratio // `x` is of type `Rational<Int>`
/// let y = 2 as Ratio // `y` is of type `Rational<Int>`
/// let z: Ratio = 2 / 3 // `z` is also of type `Rational<Int>`
///
/// print(x + y + z) // Prints "3"
/// ```
///
/// You can create an unreduced fraction by using the initializer
/// `Rational<T>.init(numerator:denominator:)`. For example:
///
/// ```swift
/// let a = Ratio(numerator: 3, denominator: 3)
/// print(a) // Prints "3/3"
/// ```
///
/// All arithmetic operations with values in canonical form (i.e. reduced to
/// lowest terms) return results in canonical form. However, operations with
/// values not in canonical form may or may not return results that are
/// themselves in canonical form. The property `canonicalized` is the canonical
/// form of any value.
///
/// Additional Considerations
/// =========================
///
/// Special Values
/// --------------
///
/// `Rational<T>` does not prohibit zero as a denominator. Any instance with a
/// positive numerator and zero denominator represents (positive) infinity; any
/// instance with a negative numerator and zero denominator represents negative
/// infinity; and any instance with zero numerator and zero denominator
/// represents NaN ("not a number").
///
/// As with floating-point types, `Rational<T>.infinity` compares greater than
/// every finite value and negative infinity, and `-Rational<T>.infinity`
/// compares less than every finite value and positive infinity. Infinite values
/// of the same sign compare equal to each other.
///
/// As with floating-point types, `Rational<T>.nan` does not compare equal to
/// any other value, including another NaN. Use the property `isNaN` to test if
/// a value is NaN. `Rational<T>` arithmetic operations are intended to
/// propagate NaN in the same manner as analogous floating-point operations.
///
/// Fixed-Width Binary Parts
/// ------------------------
///
/// When a value of type `Rational<T>` is in canonical form, the sign of the
/// numerator is the sign of the value; that is, in canonical form, the sign of
/// the denominator is always positive. Therefore, `-1 / T.min` cannot be
/// represented as a value of type `Rational<T>` because `abs(T.min)` cannot be
/// represented as a value of type `T`.
///
/// To ensure that every representable value of type `Rational<T>` has a
/// representable magnitude and reciprocal of the same type, an overflow trap
/// occurs when the division (`/`) operator is used to create a value of type
/// `Rational<T>` with numerator `T.min`.
@_fixed_layout
public struct Rational<
  T : SignedInteger & _ExpressibleByBuiltinIntegerLiteral
> where T.Magnitude : UnsignedInteger, T.Magnitude.Magnitude == T.Magnitude {
  /// The numerator of the rational value.
  public var numerator: T

  /// The denominator of the rational value.
  public var denominator: T

  /// Creates a new value from the given numerator and denominator without
  /// computing its canonical form (i.e., without reducing to lowest terms).
  ///
  /// To create a value reduced to lowest terms, use the division (`/`)
  /// operator. For example:
  ///
  /// ```swift
  /// let x = 3 / 3 as Rational<Int>
  /// print(x) // Prints "1"
  /// ```
  ///
  /// - Parameters:
  ///   - numerator: The new value's numerator.
  ///   - denominator: The new value's denominator.
  @_transparent // @_inlineable
  public init(numerator: T, denominator: T) {
    self.numerator = numerator
    self.denominator = denominator
  }

  /// Positive infinity.
  ///
  /// Infinity compares greater than all finite numbers and equal to other
  /// (positive) infinite values.
  @_transparent // @_inlineable
  public static var infinity: Rational {
    return Rational(numerator: 1, denominator: 0)
  }

  /// A quiet NaN ("not a number").
  ///
  /// A NaN compares not equal, not greater than, and not less than every value,
  /// including itself. Passing a NaN to an operation generally results in NaN.
  @_transparent // @_inlineable
  public static var nan: Rational {
    return Rational(numerator: 0, denominator: 0)
  }
}

public typealias RationalSign = FloatingPointSign

extension Rational {
  /// The canonical representation of this value.
  // @_transparent // @_inlineable
  public var canonical: Rational {
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
  public var isProper: Bool {
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

  /// The mixed form representing this value.
  ///
  /// If the value is not finite, the mixed form has zero as its whole part and
  /// the value as its fractional part.
  @_transparent // @_inlineable
  public var mixed: (whole: T, fractional: Rational) {
    if denominator == 0 { return (whole: 0, fractional: self) }
    let t = numerator.quotientAndRemainder(dividingBy: denominator)
    return (
      whole: t.quotient,
      fractional: Rational(numerator: t.remainder, denominator: denominator)
    )
  }

  /// The sign of this value.
  @_transparent // @_inlineable
  public var sign: RationalSign {
    return (denominator < 0) == (numerator < 0) ? .plus : .minus
  }

  /// Returns the reciprocal (multiplicative inverse) of this value.
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
      let a = rdm / gcd
      let b = ldm / gcd
      return a * lhs.numerator.magnitude == b * rhs.numerator.magnitude
    }
  }
}

extension Rational : Hashable {
  // @_transparent // @_inlineable
  public var hashValue: Int {
    return _fnv1a(canonical.numerator, canonical.denominator)
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
      let a = rdm / gcd
      let b = ldm / gcd
      return a * lhs.numerator.magnitude < b * rhs.numerator.magnitude
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

extension Rational
  where T : FixedWidthInteger, T.Magnitude : FixedWidthInteger {
  @_transparent // @_inlineable
  public static func < (lhs: Rational, rhs: Rational) -> Bool {
    if lhs.isNaN || rhs.isNaN { return false }
    if rhs == -.infinity { return false }
    if lhs == -.infinity { return true }

    func isMagnitudeLessThan() -> Bool {
      let ldm = lhs.denominator.magnitude
      let rdm = rhs.denominator.magnitude
      let gcd = T.Magnitude.gcd(ldm, rdm)
      let a = rdm / gcd
      let b = ldm / gcd
      // Use full-width multiplication to avoid trapping on overflow.
      let c = a.multipliedFullWidth(by: lhs.numerator.magnitude)
      let d = b.multipliedFullWidth(by: rhs.numerator.magnitude)
      return c.high < d.high || (c.high == d.high && c.low < d.low)
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

extension Rational : Strideable {
  @_transparent // @_inlineable
  public func distance(to other: Rational) -> Rational {
    return other - self
  }

  @_transparent // @_inlineable
  public func advanced(by amount: Rational) -> Rational {
    return self + amount
  }
}

public typealias Ratio = Rational<Int>
