//
//  Exponentiation.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/24/17.
//

extension BinaryInteger {
  // ---------------------------------------------------------------------------
  // MARK: Exponentiation
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  /// Returns the result of raising `base` to the power of `exponent`, rounded
  /// to a representable value.
  public static func pow(_ base: Self, _ exponent: Self) -> Self {
    var x = base, n = exponent
    if Self.isSigned && n < 0 {
      x = 1 / x
      n = 0 - n
    } else if n == 0 {
      return 1
    }
    // Exponentiate by iterative squaring.
    var y = 1 as Self
    while n > 1 {
      if n % 2 == 1 {
        y *= x
        n -= 1
      }
      x *= x
      n /= 2
    }
    return x * y
  }
}
