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
  public var magnitude: Rational {
    return sign == .minus ? -self : self
  }

  @_transparent // @_inlineable
  public static func + (lhs: Rational, rhs: Rational) -> Rational {
    if lhs.isNaN { return .nan }
    if rhs.isNaN { return .nan }
    if lhs.isInfinite {
      return rhs.isInfinite && lhs.sign != rhs.sign ? .nan : lhs
    }
    if rhs.isInfinite { return rhs }

    // FIXME: This could use some improvement and needs testing.
    let ld = lhs.denominator
    let rd = rhs.denominator
    let lcm = T(T.Magnitude.lcm(ld.magnitude, rd.magnitude))
    let a = lcm / (ld < 0 ? -ld : ld)
    let b = lcm / (rd < 0 ? -rd : rd)
    return Rational(
      numerator: a * lhs.numerator + b * rhs.numerator,
      denominator: lcm
    )._canonicalized()
  }

  @_transparent // @_inlineable
  public static func - (lhs: Rational, rhs: Rational) -> Rational {
    return lhs + (-rhs)
  }

  @_transparent // @_inlineable
  public static func * (lhs: Rational, rhs: Rational) -> Rational {
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
        numerator: T(lnm / a) * T(rnm / b), denominator: T(ldm / b) * T(rdm / a)
      )
    }
    return Rational(
      // Note that computing `-T(lnm / a) * T(rnm / b)` permits the numerator to
      // be equal to `T.min` if `T` is a signed fixed-width integer type, but
      // computing `-T((lnm / a) * (rnm / b))` does not, as `-T.min` is not
      // representable as a `T`.
      numerator: -T(lnm / a) * T(rnm / b), denominator: T(ldm / b) * T(rdm / a)
    )
  }

  // @_transparent // @_inlineable
  public static func += (lhs: inout Rational, rhs: Rational) {
    // FIXME: Implement something better.
    lhs = lhs + rhs
  }

  // @_transparent // @_inlineable
  public static func -= (lhs: inout Rational, rhs: Rational) {
    // FIXME: Implement something better.
    lhs = lhs - rhs
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
    if lhs.isNaN { return .nan }
    if rhs.isNaN { return .nan }
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
    // FIXME: complete the rest of this algorithm, keeping in mind that it is
    // necessary to change the sign of `a` and `b` before using them as factors.
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

extension Rational {
  @_transparent // @_inlineable
  public static func / (lhs: Rational, rhs: Rational) -> Rational {
    return lhs * rhs.reciprocal()
  }

  // TODO: `%`, `rounded(_:)`
}
