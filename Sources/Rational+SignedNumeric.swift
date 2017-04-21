//
//  Rational+SignedNumeric.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

extension Rational : Numeric {
  @_transparent // @_inlineable
  public init?<U>(exactly source: U) where U : BinaryInteger {
    guard let t = T(exactly: source) else { return nil }
    self.numerator = t
    self.denominator = 1
  }

  @_transparent // @_inlineable
  public static func + (lhs: Rational, rhs: Rational) -> Rational {
    if lhs.isNaN || rhs.isNaN { return .nan }
    if lhs.isInfinite {
      return rhs.isInfinite && lhs.sign != rhs.sign ? .nan : lhs
    }
    if rhs.isInfinite { return rhs }

    let ldm = lhs.denominator.magnitude
    let rdm = rhs.denominator.magnitude
    let gcd = T.Magnitude.gcd(ldm, rdm)
    let a = ldm / gcd
    let b = rdm / gcd

    let n: T
    let d = T(ldm / gcd * rdm)
    switch (lhs.sign, rhs.sign) {
    case (.plus, .plus):
      n = T(a * lhs.numerator.magnitude) + T(b * rhs.numerator.magnitude)
    case (.plus, .minus):
      n = T(a * lhs.numerator.magnitude) - T(b * rhs.numerator.magnitude)
    case (.minus, .plus):
      n = T(b * rhs.numerator.magnitude) - T(a * lhs.numerator.magnitude)
    case (.minus, .minus):
      n = -T(a * lhs.numerator.magnitude) - T(b * rhs.numerator.magnitude)
    }
    return Rational(numerator: n, denominator: d).canonical
  }

  // @_transparent // @_inlineable
  public static func += (lhs: inout Rational, rhs: Rational) {
    // FIXME: Implement something better.
    lhs = lhs + rhs
  }

  @_transparent // @_inlineable
  public static func - (lhs: Rational, rhs: Rational) -> Rational {
    return lhs + (-rhs)
  }

  // @_transparent // @_inlineable
  public static func -= (lhs: inout Rational, rhs: Rational) {
    // FIXME: Implement something better.
    lhs = lhs + (-rhs)
  }
  
  @_transparent // @_inlineable
  public static func * (lhs: Rational, rhs: Rational) -> Rational {
    if lhs.isNaN || rhs.isNaN { return .nan }
    if lhs.isInfinite {
      if rhs.isZero { return .nan }
      return lhs.sign != rhs.sign
        ? lhs.numerator < 0 ? lhs : -lhs
        : lhs.numerator < 0 ? -lhs : lhs
    }
    if rhs.isInfinite {
      if lhs.isZero { return .nan }
      return lhs.sign != rhs.sign
        ? rhs.numerator < 0 ? rhs : -rhs
        : rhs.numerator < 0 ? -rhs : rhs
    }
    
    let lnm = lhs.numerator.magnitude, ldm = lhs.denominator.magnitude
    let rnm = rhs.numerator.magnitude, rdm = rhs.denominator.magnitude

    // Note that if `T` is a signed fixed-width integer type, `gcd(lnm, rdm)` or
    // `gcd(rnm, ldm)` could be equal to `-T.min`, which is not representable as
    // a `T`. This is why the following arithmetic is performed with values of
    // type `T.Magnitude`.
    let a = T.Magnitude.gcd(lnm, rdm)
    guard a != 0 else { return .nan }
    let b = T.Magnitude.gcd(rnm, ldm)
    guard b != 0 else { return .nan }

    if lhs.sign == rhs.sign {
      return Rational(
        numerator: T(lnm / a * (rnm / b)), denominator: T(ldm / b * (rdm / a))
      )
    }
    return Rational(
      numerator: -T(lnm / a * (rnm / b)), denominator: T(ldm / b * (rdm / a))
    )
  }

  // @_transparent // @_inlineable
  public static func *= (lhs: inout Rational, rhs: Rational) {
    // FIXME: Implement something better.
    lhs = lhs * rhs
  }
}

extension Rational where T.Magnitude : FixedWidthInteger {
  /*
  @_transparent // @_inlineable
  public static func + (lhs: Rational, rhs: Rational) -> Rational {
    if lhs.isNaN || rhs.isNaN { return .nan }
    if lhs.isInfinite {
      return rhs.isInfinite && lhs.sign != rhs.sign ? .nan : lhs
    }
    if rhs.isInfinite { return rhs }

    let ldm = lhs.denominator.magnitude
    let rdm = rhs.denominator.magnitude
    // For full-width integers, we can make use of full-width multiplication.
    let lcm = T.Magnitude.lcmFullWidth(ldm, rdm)
    let a = ldm.magnitude.dividingFullWidth(lcm)
    let b = rdm.magnitude.dividingFullWidth(lcm)
    // TODO: Complete the rest of this algorithm.
  }
  */
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

public typealias RationalRoundingRule = FloatingPointRoundingRule

extension Rational {
  @_transparent // @_inlineable
  public static func / (lhs: Rational, rhs: Rational) -> Rational {
    return lhs * rhs.reciprocal()
  }

  // @_transparent // @_inlineable
  public static func /= (lhs: inout Rational, rhs: Rational) {
    // FIXME: Implement something better.
    lhs = lhs * rhs.reciprocal()
  }

  // TODO: `%`

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
    _ rule: RationalRoundingRule = .toNearestOrAwayFromZero
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
  public mutating func round(
    _ rule: RationalRoundingRule = .toNearestOrAwayFromZero
  ) {
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
        // Tie.
        case (2, 0):
          if rule == .toNearestOrEven && numerator % 2 == 0 { break }
          fallthrough
        // Nearest is away from zero.
        case (1, _):
          if f > 0 { numerator += 1 } else { numerator -= 1 }
        // Nearest is toward zero.
        default:
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
