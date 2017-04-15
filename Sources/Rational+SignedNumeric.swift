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
    let a = T.gcd(lhs.numerator, rhs.denominator)
    guard a != 0 else { return .nan }
    let b = T.gcd(rhs.numerator, lhs.denominator)
    guard b != 0 else { return .nan }
    return Rational(
      numerator: (lhs.numerator / a) * (rhs.numerator / b),
      denominator: (lhs.denominator / b) * (rhs.denominator / a)
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
