//
//  Rational+SignedNumeric.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

extension Rational /* : Numeric */ {
  @_transparent // @_inlineable
  public var magnitude: Rational {
    return sign == .minus ? -self : self
  }

  // TODO: `+`, `-`

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
}

extension Rational /* : SignedNumeric */ {
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
