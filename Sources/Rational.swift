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
/// -------------------------
///
/// ### Special Values
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
/// ### Fixed-Width Binary Parts
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
public struct Rational<T : SignedInteger>
where T : _ExpressibleByBuiltinIntegerLiteral, T.Magnitude : UnsignedInteger,
  T.Magnitude.Magnitude == T.Magnitude {
  /// The numerator of the rational value.
  public var numerator: T

  /// The denominator of the rational value.
  public var denominator: T

  // ---------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------

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

  // @_transparent // @_inlineable
  /// Creates a new rational value from the given binary integer.
  ///
  /// If `source` or its magnitude is not representable as a numerator of type
  /// `T`, a runtime error may occur.
  ///
  /// - Parameters:
  ///   - source: A binary integer to convert to a rational value.
  public init<Source : BinaryInteger>(_ source: Source) {
    let t = T(source)
    // Ensure that `t.magnitude` is representable as a `T`.
    _ = T(t.magnitude)
    self.numerator = t
    self.denominator = 1
  }

  // @_transparent // @_inlineable
  /// Creates a new rational value from the given binary floating-point value.
  ///
  /// ...
  public init<Source : BinaryFloatingPoint>(_ source: Source) {
    // TODO: Document this initializer.
    if source.isNaN { self = .nan; return }
    if source == .infinity { self = .infinity; return }
    if source == -.infinity { self = -.infinity; return }
    if source.isZero { self = 0; return }

    let exponent = source.exponent
    let significandWidth = source.significandWidth
    if significandWidth <= exponent {
      self.numerator = T(source)
      self.denominator = 1
      return
    }
    let shift = significandWidth - Int(exponent)
    let numerator = T(source * Source(1 &<< shift))
    // Ensure that `numerator.magnitude` is representable as a `T`.
    _ = T(numerator.magnitude)
    let denominator = T(1 &<< shift)
    // Ensure that `denominator.magnitude` is representable as a `T`.
    _ = T(denominator.magnitude)
    self.numerator = numerator
    self.denominator = denominator
  }
}

extension Rational
where T : FixedWidthInteger, T.Magnitude : FixedWidthInteger {
  // ---------------------------------------------------------------------------
  // MARK: Initializers (Fixed-Width)
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  /// Creates a new rational value from the given binary floating-point value.
  ///
  /// ...
  public init?<Source : BinaryFloatingPoint>(exactly source: Source) {
    // TODO: Document this initializer.
    if source.isNaN { self = .nan; return }
    if source == .infinity { self = .infinity; return }
    if source == -.infinity { self = -.infinity; return }
    if source.isZero { self = 0; return } // Consider -0.0 to be exactly 0.

    let exponent = source.exponent
    let significandWidth = source.significandWidth
    let bitWidth = T.bitWidth
    if significandWidth <= exponent {
      guard exponent + 1 < bitWidth else { return nil }
      self.numerator = T(source)
      self.denominator = 1
      return
    }
    let shift = significandWidth - Int(exponent)
    guard significandWidth + 1 < bitWidth && shift < bitWidth else {
      return nil
    }
    let numerator = T(source * Source(1 &<< shift))
    // Ensure that `numerator.magnitude` is representable as a `T`.
    guard let _ = T(exactly: numerator.magnitude) else { return nil }
    let denominator = T(1 &<< shift)
    // Ensure that `denominator.magnitude` is representable as a `T`.
    guard let _ = T(exactly: denominator.magnitude) else { return nil }
    self.numerator = numerator
    self.denominator = denominator
  }
}

extension Rational {
  // ---------------------------------------------------------------------------
  // MARK: Static Properties
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // MARK: Static Methods
  // ---------------------------------------------------------------------------

  /// Compares the (finite) magnitude of two finite values, returning -1 if
  /// `lhs.magnitude` is less than `rhs.magnitude`, 0 if `lhs.magnitude` is
  /// equal to `rhs.magnitude`, or 1 if `lhs.magnitude` is greater than
  /// `rhs.magnitude`.
  // @_versioned
  internal static func _compareFiniteMagnitude(
    _ lhs: Rational, _ rhs: Rational
  ) -> Int {
    let ldm = lhs.denominator.magnitude
    let rdm = rhs.denominator.magnitude
    let gcd = T.Magnitude.gcd(ldm, rdm)
    let a = rdm / gcd * lhs.numerator.magnitude
    let b = ldm / gcd * rhs.numerator.magnitude
    return a == b ? 0 : (a < b ? -1 : 1)
    // FIXME: Use full-width multiplication to avoid trapping on overflow
    // where `T : FixedWidthInteger, T.Magnitude : FixedWidthInteger`.
    /*
    let a = (rdm / gcd).multipliedFullWidth(by: lhs.numerator.magnitude)
    let b = (ldm / gcd).multipliedFullWidth(by: rhs.numerator.magnitude)
    return a.high == b.high
      ? (a.low == b.low ? 0 : (a.low < b.low ? -1 : 1))
      : (a.high < b.high ? -1 : 1)
    */
  }

  /// Returns the quotient obtained by dividing the first value by the second,
  /// trapping in case of arithmetic overflow.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value by which to divide `lhs`.
  @_transparent // @_inlineable
  public static func / (lhs: Rational, rhs: Rational) -> Rational {
    return lhs * rhs.reciprocal()
  }

  /// Divides the left-hand side by the right-hand side and stores the quotient
  /// in the left-hand side, trapping in case of arithmetic overflow.
  ///
  /// - Parameters:
  ///   - lhs: The value to divide.
  ///   - rhs: The value by which to divide `lhs`.
  @_transparent // @_inlineable
  public static func /= (lhs: inout Rational, rhs: Rational) {
    lhs = lhs * rhs.reciprocal()
  }

  // ---------------------------------------------------------------------------
  // MARK: Instance Properties
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  /// The canonical representation of this value.
  public var canonical: Rational {
    let nm = numerator.magnitude, dm = denominator.magnitude
    // Note that if `T` is a signed fixed-width integer type, `gcd(nm, dm)`
    // could be equal to `-T.min`, which is not representable as a `T`. This is
    // why the following arithmetic is performed with values of type
    // `T.Magnitude`.
    let gcd = T.Magnitude.gcd(nm, dm)
    guard gcd != 0 else { return self }
    let n = sign == .plus ? T(nm / gcd) : -T(nm / gcd)
    let d = T(dm / gcd)
    return Rational(numerator: n, denominator: d)
  }

  /// A Boolean value indicating whether the instance's representation is in
  /// canonical form.
  @_transparent // @_inlineable
  public var isCanonical: Bool {
    if denominator > 0 {
      return T.Magnitude.gcd(numerator.magnitude, denominator.magnitude) == 1
    }
    return denominator == 0 && numerator.magnitude <= 1
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
  public var sign: Sign {
    return numerator == 0 || (denominator < 0) == (numerator < 0)
      ? .plus
      : .minus
  }

  // ---------------------------------------------------------------------------
  // MARK: Instance Methods
  // ---------------------------------------------------------------------------

  /// Returns the reciprocal (multiplicative inverse) of this value.
  @_transparent // @_inlineable
  public func reciprocal() -> Rational {
    return numerator < 0
      ? Rational(numerator: -denominator, denominator: -numerator)
      : Rational(numerator: denominator, denominator: numerator)
  }

  /// Returns this value rounded to an integral value using the specified
  /// rounding rule.
  ///
  /// ```swift
  /// let x = 7 / 2 as Rational<Int>
  /// print(x.rounded()) // Prints "4"
  /// print(x.rounded(.towardZero)) // Prints "3"
  /// print(x.rounded(.up)) // Prints "4"
  /// print(x.rounded(.down)) // Prints "3"
  /// ```
  ///
  /// See the `FloatingPointRoundingRule` enumeration for more information about
  /// the available rounding rules.
  ///
  /// - Parameters:
  ///   - rule: The rounding rule to use.
  ///
  /// - SeeAlso: `round(_:)`, `RoundingRule`
  @_transparent // @_inlineable
  public func rounded(
    _ rule: RoundingRule = .toNearestOrAwayFromZero
  ) -> Rational {
    var t = self
    t.round(rule)
    return t
  }

  /// Rounds the value to an integral value using the specified rounding rule.
  ///
  /// ```swift
  /// var x = 7 / 2 as Rational<Int>
  /// x.round() // x == 4
  ///
  /// var x = 7 / 2 as Rational<Int>
  /// x.round(.towardZero) // x == 3
  ///
  /// var x = 7 / 2 as Rational<Int>
  /// x.round(.up) // x == 4
  ///
  /// var x = 7 / 2 as Rational<Int>
  /// x.round(.down) // x == 3
  /// ```
  ///
  /// See the `FloatingPointRoundingRule` enumeration for more information about
  /// the available rounding rules.
  ///
  /// - Parameters:
  ///   - rule: The rounding rule to use.
  ///
  /// - SeeAlso: `round(_:)`, `RoundingRule`
  @_transparent // @_inlineable
  public mutating func round(_ rule: RoundingRule = .toNearestOrAwayFromZero) {
    if denominator == 0 { return }

    let f: T
    (numerator, f) = numerator.quotientAndRemainder(dividingBy: denominator)
    // Rounding rules only come into play if the fractional part is non-zero.
    if f != 0 {
      switch rule {
      case .toNearestOrAwayFromZero:
        fallthrough
      case .toNearestOrEven:
        switch denominator.magnitude.quotientAndRemainder(
          dividingBy: f.magnitude
        ) {
        case (2, 0): // Tie.
          if rule == .toNearestOrEven && numerator % 2 == 0 { break }
          fallthrough
        case (1, _): // Nearest is away from zero.
          if f > 0 { numerator += 1 } else { numerator -= 1 }
        default: // Nearest is toward zero.
          break
        }
      case .up:
        if f > 0 { numerator += 1 }
      case .down:
        if f < 0 { numerator -= 1 }
      case .towardZero:
        break
      case .awayFromZero:
        if f > 0 { numerator += 1 } else { numerator -= 1 }
      }
    }
    denominator = 1
  }
}

extension Rational : ExpressibleByIntegerLiteral {
  // ---------------------------------------------------------------------------
  // MARK: ExpressibleByIntegerLiteral
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public init(integerLiteral value: T) {
    self.numerator = value
    self.denominator = 1
  }
}

extension Rational : CustomStringConvertible {
  // ---------------------------------------------------------------------------
  // MARK: CustomStringConvertible
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public var description: String {
    if numerator == 0 { return denominator == 0 ? "nan" : "0" }
    if denominator == 0 { return numerator < 0 ? "-inf" : "inf" }
    return denominator == 1 ? "\(numerator)" : "\(numerator)/\(denominator)"
  }
}

extension Rational : Equatable {
  // ---------------------------------------------------------------------------
  // MARK: Equatable
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  public static func == (lhs: Rational, rhs: Rational) -> Bool {
    if lhs.denominator == 0 {
      if lhs.numerator == 0 { return false }
      if lhs.numerator > 0 { return rhs.denominator == 0 && rhs.numerator > 0 }
      return rhs.denominator == 0 && rhs.numerator < 0
    }
    if rhs.denominator == 0 { return false }

    return lhs.sign == rhs.sign && _compareFiniteMagnitude(lhs, rhs) == 0
  }
}

extension Rational : Hashable {
  // ---------------------------------------------------------------------------
  // MARK: Hashable
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  public var hashValue: Int {
    let t = canonical
    return _fnv1a(t.numerator, t.denominator)
  }
}

extension Rational : Comparable {
  // ---------------------------------------------------------------------------
  // MARK: Comparable
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  public static func < (lhs: Rational, rhs: Rational) -> Bool {
    if lhs.denominator == 0 {
      if lhs.numerator >= 0 { return false }
      return rhs.denominator != 0 || rhs.numerator > 0
    }
    if rhs.denominator == 0 { return rhs.numerator > 0 }

    switch (lhs.sign, rhs.sign) {
    case (.plus, .minus):
      return false
    case (.minus, .plus):
      return true
    case (.plus, .plus):
      return _compareFiniteMagnitude(lhs, rhs) < 0
    case (.minus, .minus):
      return _compareFiniteMagnitude(lhs, rhs) > 0
    }
  }

  @_transparent // @_inlineable
  public static func > (lhs: Rational, rhs: Rational) -> Bool {
    return rhs < lhs
  }

  // @_transparent // @_inlineable
  public static func <= (lhs: Rational, rhs: Rational) -> Bool {
    if lhs.denominator == 0 {
      if lhs.numerator == 0 { return false }
      if lhs.numerator > 0 { return rhs.denominator == 0 && rhs.numerator > 0 }
      return rhs.denominator != 0 || rhs.numerator != 0
    }
    if rhs.denominator == 0 { return rhs.numerator > 0 }

    switch (lhs.sign, rhs.sign) {
    case (.plus, .minus):
      return false
    case (.minus, .plus):
      return true
    case (.plus, .plus):
      return _compareFiniteMagnitude(lhs, rhs) <= 0
    case (.minus, .minus):
      return _compareFiniteMagnitude(lhs, rhs) >= 0
    }
  }

  @_transparent // @_inlineable
  public static func >= (lhs: Rational, rhs: Rational) -> Bool {
    return rhs <= lhs
  }
}

extension Rational : Strideable, _Strideable {
  // ---------------------------------------------------------------------------
  // MARK: Strideable
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public func distance(to other: Rational) -> Rational {
    return other - self
  }

  @_transparent // @_inlineable
  public func advanced(by amount: Rational) -> Rational {
    return self + amount
  }
}

extension Rational : Numeric {
  // ---------------------------------------------------------------------------
  // MARK: Numeric
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  public init?<U>(exactly source: U) where U : BinaryInteger {
    guard let t = T(exactly: source) else { return nil }
    // Ensure that `t.magnitude` is representable as a `T`.
    guard let _ = T(exactly: t.magnitude) else { return nil }
    self.numerator = t
    self.denominator = 1
  }

  // @_transparent // @_inlineable
  public static func + (lhs: Rational, rhs: Rational) -> Rational {
    if lhs.denominator == 0 {
      if rhs.denominator != 0 || lhs.numerator == 0 { return lhs }
      if lhs.numerator > 0 { return rhs.numerator < 0 ? .nan : rhs }
      return rhs.numerator > 0 ? .nan : rhs
    }
    if rhs.denominator == 0 { return rhs }

    let ldm = lhs.denominator.magnitude
    let rdm = rhs.denominator.magnitude
    let gcd = T.Magnitude.gcd(ldm, rdm)
    let a = T(rdm / gcd * lhs.numerator.magnitude)
    let b = T(ldm / gcd * rhs.numerator.magnitude)
    let n = lhs.sign == .plus
      ? (rhs.sign == .plus ? a + b : a - b)
      : (rhs.sign == .plus ? b - a : -a - b)
    let d = T(ldm / gcd * rdm)
    return Rational(numerator: n, denominator: d).canonical
  }

  @_transparent // @_inlineable
  public static func += (lhs: inout Rational, rhs: Rational) {
    lhs = lhs + rhs
  }

  @_transparent // @_inlineable
  public static func - (lhs: Rational, rhs: Rational) -> Rational {
    return lhs + (-rhs)
  }

  @_transparent // @_inlineable
  public static func -= (lhs: inout Rational, rhs: Rational) {
    lhs = lhs + (-rhs)
  }
  
  // @_transparent // @_inlineable
  public static func * (lhs: Rational, rhs: Rational) -> Rational {
    if lhs.denominator == 0 {
      if rhs.numerator == 0 { return .nan }
      return rhs.sign == .plus ? lhs : -lhs
    }
    if rhs.denominator == 0 {
      if lhs.numerator == 0 { return .nan }
      return lhs.sign == .plus ? rhs : -rhs
    }
    
    let lnm = lhs.numerator.magnitude, ldm = lhs.denominator.magnitude
    let rnm = rhs.numerator.magnitude, rdm = rhs.denominator.magnitude
    // Note that if `T` is a signed fixed-width integer type, `gcd(lnm, rdm)` or
    // `gcd(rnm, ldm)` could be equal to `-T.min`, which is not representable as
    // a `T`. This is why the following arithmetic is performed with values of
    // type `T.Magnitude`.
    let a = T.Magnitude.gcd(lnm, rdm)
    let b = T.Magnitude.gcd(rnm, ldm)
    let n = lhs.sign == rhs.sign
      ? T(lnm / a * (rnm / b))
      : -T(lnm / a * (rnm / b))
    let d = T(ldm / b * (rdm / a))
    return Rational(numerator: n, denominator: d)
  }

  @_transparent // @_inlineable
  public static func *= (lhs: inout Rational, rhs: Rational) {
    lhs = lhs * rhs
  }
}

extension Rational : SignedNumeric {
  // ---------------------------------------------------------------------------
  // MARK: SignedNumeric
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public static prefix func - (operand: Rational) -> Rational {
    return Rational(
      numerator: -operand.numerator, denominator: operand.denominator
    )
  }

  @_transparent // @_inlineable
  public mutating func negate() {
    numerator.negate()
  }
}

/// Returns the absolute value (magnitude) of `x`.
@_transparent
public func abs<T>(_ x: Rational<T>) -> Rational<T> {
  return x.magnitude
}

/// Returns the closest integral value greater than or equal to `x`.
@_transparent
public func ceil<T>(_ x: Rational<T>) -> Rational<T> {
  return x.rounded(.up)
}

/// Returns the closest integral value less than or equal to `x`.
@_transparent
public func floor<T>(_ x: Rational<T>) -> Rational<T> {
  return x.rounded(.down)
}

/// Returns the closest integral value; if two values are equally close, returns
/// the one with greater magnitude.
@_transparent
public func round<T>(_ x: Rational<T>) -> Rational<T> {
  return x.rounded()
}

/// Returns the closest integral value with magnitude less than or equal to that
/// of `x`.
@_transparent
public func trunc<T>(_ x: Rational<T>) -> Rational<T> {
  return x.rounded(.towardZero)
}

public typealias Ratio = Rational<Int>

// MARK: -

extension BinaryInteger {
  // ---------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------

  /// Creates a new binary integer from the given rational value, if it can be
  /// represented exactly.
  ///
  /// If `source` is not representable exactly, the result is `nil`.
  ///
  /// - Parameters:
  ///   - source: A rational value to convert to a binary integer.
  @_transparent // @_inlineable
  public init?<U>(exactly source: Rational<U>) {
    let (whole, fraction) = source.mixed
    guard fraction.isZero, let exact = Self(exactly: whole) else { return nil }
    self = exact
  }

  /// Creates a new binary integer from the given rational value, rounding
  /// toward zero.
  ///
  /// If `source` is outside the bounds of this type after rounding toward zero,
  /// a runtime error may occur.
  ///
  /// - Parameters:
  ///   - source: A rational value to convert to a binary integer.
  @_transparent // @_inlineable
  public init<U>(_ source: Rational<U>) {
    self = Self(source.mixed.whole)
  }
}
