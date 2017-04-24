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
    let d = T(ldm / gcd * rdm)
    let a = rdm / gcd
    let b = ldm / gcd
    let n: T
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

  @_transparent // @_inlineable
  public static func *= (lhs: inout Rational, rhs: Rational) {
    lhs = lhs * rhs
  }
}

/*
extension Rational
  where T : FixedWidthInteger, T.Magnitude : FixedWidthInteger {
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
    let a = rdm / gcd
    let b = ldm / gcd

    // For full-width integers, we can make use of full-width multiplication.
    // For now, we'll define some necessary arithmetic operations.
    func _add(
      _ lhs: inout (high: T, low: T.Magnitude),
      _ rhs: (high: T, low: T.Magnitude)
    ) {
      let overflow: ArithmeticOverflow
      (lhs.low, overflow) = lhs.low.addingReportingOverflow(rhs.low)
      if overflow == .overflow {
        lhs.high += rhs.high + 1
      } else {
        lhs.high += rhs.high
      }
    }

    func _negate(_ x: inout (high: T, low: T.Magnitude)) {
      let overflow: ArithmeticOverflow
      (x.low, overflow) = (~x.low).addingReportingOverflow(1)
      if overflow == .overflow {
        x.high = (~x.high) + 1
      } else {
        x.high = ~x.high
      }
    }

    func _magnitude(_ x: (high: T, low: T.Magnitude))
      -> (high: T.Magnitude, low: T.Magnitude) {
      guard x.high < 0 else { return (high: T.Magnitude(x.high), low: x.low) }
      let (low, overflow) = (~x.low).addingReportingOverflow(1)
      return (
        high: overflow == .overflow
          ? T.Magnitude(~x.high) + 1
          : T.Magnitude(~x.high),
        low: low
      )
    }

    func _gcd(
      _ a: (high: T.Magnitude, low: T.Magnitude),
      _ b: (high: T.Magnitude, low: T.Magnitude)
    ) -> (high: T.Magnitude, low: T.Magnitude) {
      if a.high == 0 && b.high == 0 {
        return (high: 0, low: T.Magnitude.gcd(a.low, b.low))
      }

      if a.high == 0 && a.low == 0 { return b } // gcd(0, b) == b
      if b.high == 0 && b.low == 0 { return a } // gcd(a, 0) == a

      var a = a, b = b, shift = 0
      let w = T.Magnitude.bitWidth

      // Equivalent to:
      // `while ((a | b) & 1) == 0 { a &>>= 1; b &>>= 1; shift += 1 }`.
      while ((a.low | b.low) & 1) == 0 && shift < w {
        a.low &>>= 1
        b.low &>>= 1
        shift += 1
      }
      if shift == w {
        swap(&a.high, &a.low)
        swap(&b.high, &b.low)
        while ((a.low | b.low) & 1) == 0 {
          a.low &>>= 1
          b.low &>>= 1
          shift += 1
        }
      } else {
        // We know that at least one of `a.high` and `b.high` is not zero.
        let mask = (1 &<< shift) - 1 as T.Magnitude
        let reshift = w - shift
        if a.high != 0 {
          a.low |= (mask & a.high) &<< reshift
          a.high &>>= shift
        }
        if b.high != 0 {
          b.low |= (mask & b.high) &<< reshift
          b.high &>>= shift
        }
      }
      // Now, shift is equal to log2(k), where k is the greatest power of 2
      // dividing a and b.

      // Equivalent to `while (a & 1) == 0 { a &>>= 1 }`.
      if a.high == 0 {
        while (a.low & 1) == 0 {
          a.low &>>= 1
        }
      } else {
        var counter = 0
        while (a.low & 1) == 0 && counter < w {
          a.low &>>= 1
          counter += 1
        }
        if counter == w {
          swap(&a.high, &a.low)
          while (a.low & 1) == 0 {
            a.low &>>= 1
          }
        } else {
          let mask = (1 &<< counter) - 1 as T.Magnitude
          a.low |= (mask & a.high) &<< (w - counter)
          a.high &>>= counter
        }
      }
      // Now, a is odd.

      repeat {
        // Equivalent to `while (b & 1) == 0 { b &>>= 1 }`.
        if b.high == 0 {
          while (b.low & 1) == 0 {
            b.low &>>= 1
          }
        } else {
          var counter = 0
          while (b.low & 1) == 0 && counter < w {
            b.low &>>= 1
            counter += 1
          }
          if counter == w {
            swap(&b.high, &b.low)
            while (b.low & 1) == 0 {
              b.low &>>= 1
            }
          } else {
            let mask = (1 &<< counter) - 1 as T.Magnitude
            b.low |= (mask & b.high) &<< (w - counter)
            b.high &>>= counter
          }
        }
        // Now, b is odd.

        // Equivalent to `if a > b { swap(&a, &b) }`.
        if a.high > b.high || (a.high == b.high && a.low > b.low) {
          swap(&a, &b)
        }
        // Now, a < b.

        // Equivalent to `b -= a`.
        let overflow: ArithmeticOverflow
        (b.low, overflow) = b.low.subtractingReportingOverflow(a.low)
        if overflow == .overflow {
          b.high -= a.high + 1
        } else {
          b.high -= a.high
        }
      } while b.low != 0 || b.high != 0

      // Restore common factors of 2.
      if shift >= w {
        return (high: a.low &<< (shift - w), low: 0)
      }
      a.high &<<= shift
      let mask = ~((1 &<< shift) - 1 as T.Magnitude)
      a.high |= (mask & a.low) &>> (w - shift)
      a.low &<<= shift
      return a
    }

    func _dividing(
      _ lhs: (high: T.Magnitude, low: T.Magnitude),
      _ rhs: (high: T.Magnitude, low: T.Magnitude)
    ) -> T.Magnitude {
      // TODO: Implement this function.
      fatalError()
    }

    var xm = a.multipliedFullWidth(by: lhs.numerator.magnitude)
    var x = (high: T(xm.high), low: xm.low)
    let ym = b.multipliedFullWidth(by: rhs.numerator.magnitude)
    var y = (high: T(ym.high), low: ym.low)
    switch (lhs.sign, rhs.sign) {
    case (.plus, .plus):
      break
    case (.plus, .minus):
      _negate(&y)
    case (.minus, .plus):
      _negate(&x)
    case (.minus, .minus):
      _negate(&x)
      _negate(&y)
    }
    _add(&x, y)
    xm = _magnitude(x)
    let dm = (ldm / gcd).multipliedFullWidth(by: rdm)

    // Perform a full-width gcd operation.
    let g = _gcd(xm, dm)
    guard g.low != 0 || g.high != 0 else {
      let d = (high: T(dm.high), low: dm.low)
      return Rational(
        numerator: (1 as T).dividingFullWidth(x).quotient,
        denominator: (1 as T).dividingFullWidth(d).quotient
      )
    }

    let n = _dividing(xm, g)
    let d = _dividing(dm, g)
    if x.high >= 0 {
      return Rational(numerator: T(n), denominator: T(d))
    }
    return Rational(numerator: -T(n), denominator: T(d))
  }
}
*/

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
