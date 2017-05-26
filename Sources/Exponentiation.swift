//
//  Exponentiation.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/24/17.
//

extension BinaryInteger {
  /// Returns the result of raising `base` to the power of `exponent`, rounded
  /// to a representable value.
  // @_transparent // @_inlineable
  public static func pow(_ base: Self, _ exponent: Self) -> Self {
    var x = base, n = exponent
    if Self.isSigned && n < (0 as Self) {
      x = 1 / x
      n = 0 - n
    } else if n == (0 as Self) {
      return 1
    }
    // Exponentiate by iterative squaring.
    var y = 1 as Self
    while n > (1 as Self) {
      if n % 2 == (1 as Self) {
        y *= x
        n -= 1
      }
      x *= x
      n /= 2
    }
    return x * y
  }
}
