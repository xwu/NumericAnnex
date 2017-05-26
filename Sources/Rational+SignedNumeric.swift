//
//  Rational+SignedNumeric.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

extension Rational : Numeric {
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
    if lhs.denominator == (0 as T) {
      if rhs.denominator != (0 as T) || lhs.numerator == (0 as T) {
        return lhs
      }
      if lhs.numerator > (0 as T) {
        return rhs.numerator < (0 as T) ? .nan : rhs
      }
      return rhs.numerator > (0 as T) ? .nan : rhs
    }
    if rhs.denominator == (0 as T) { return rhs }

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
    if lhs.denominator == (0 as T) {
      if rhs.numerator == (0 as T) { return .nan }
      return rhs.sign == .plus ? lhs : -lhs
    }
    if rhs.denominator == (0 as T) {
      if lhs.numerator == (0 as T) { return .nan }
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

extension BinaryInteger {
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

  /// Creates a new binary integer from the given rational value, truncating any
  /// fractional part.
  ///
  /// If `source` is outside the bounds of this type after truncation, a runtime
  /// error may occur.
  ///
  /// - Parameters:
  ///   - source: A rational value to convert to a binary integer.
  @_transparent // @_inlineable
  public init<U>(_ source: Rational<U>) {
    self = Self(source.mixed.whole)
  }
}

extension Rational : SignedNumeric {
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

extension Rational {
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
  /// - SeeAlso: `round(_:)`, `FloatingPointRoundingRule`
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
  /// - SeeAlso: `round(_:)`, `FloatingPointRoundingRule`
  @_transparent // @_inlineable
  public mutating func round(_ rule: RoundingRule = .toNearestOrAwayFromZero) {
    if denominator == 0 { return }

    let f: T
    (numerator, f) = numerator.quotientAndRemainder(dividingBy: denominator)
    // Rounding rules only come into play if the fractional part is non-zero.
    if f != (0 as T) {
      switch rule {
      case .toNearestOrAwayFromZero:
        fallthrough
      case .toNearestOrEven:
        switch denominator.magnitude.quotientAndRemainder(
          dividingBy: f.magnitude
        ) {
        case (2, 0): // Tie.
          if rule == .toNearestOrEven && numerator % 2 == (0 as T) { break }
          fallthrough
        case (1, _): // Nearest is away from zero.
          if f > (0 as T) { numerator += 1 } else { numerator -= 1 }
        default: // Nearest is toward zero.
          break
        }
      case .up:
        if f > (0 as T) { numerator += 1 }
      case .down:
        if f < (0 as T) { numerator -= 1 }
      case .towardZero:
        break
      case .awayFromZero:
        if f > (0 as T) { numerator += 1 } else { numerator -= 1 }
      }
    }
    denominator = 1
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

/// Returns the closest integral value with magnitude less than or equal to `x`.
@_transparent
public func trunc<T>(_ x: Rational<T>) -> Rational<T> {
  return x.rounded(.towardZero)
}
