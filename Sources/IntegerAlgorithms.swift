//
//  IntegerAlgorithms.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

extension BinaryInteger {
  // ---------------------------------------------------------------------------
  // MARK: Exponentiation
  // ---------------------------------------------------------------------------

  // We need to factor out the implementation of `**` so that the tie-breaking
  // operators implemented in extensions to concrete integer types can call it.
  @_versioned
  internal static func _pow(_ lhs: Self, _ rhs: Self) -> Self {
    var x = lhs, n = rhs
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
      }
      x *= x
      n /= 2
    }
    return x * y
  }

  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: Self, rhs: Self) -> Self {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout Self, rhs: Self) {
    lhs = lhs ** rhs
  }

  /// Returns the result of raising `base` to the power of `exponent`, rounded
  /// to a representable value (deprecated).
  @available(*, deprecated, message: "Use operator instead")
  public static func pow(_ base: Self, _ exponent: Self) -> Self {
    return base ** exponent
  }

  // ---------------------------------------------------------------------------
  // MARK: Square Root
  // ---------------------------------------------------------------------------

  /// Returns the square root of `x`, rounding toward zero. If `x` is negative,
  /// a runtime error may occur.
  @_transparent // @_inlineable
  public static func sqrt(_ x: Self) -> Self {
    precondition(!Self.isSigned || x >= 0)
    var shift = x.bitWidth - 1
    shift -= shift % 2

    var x = x
    var result = 0 as Self
    while shift >= 0 {
      result *= 2
      let temporary = 2 * result + 1
      if temporary <= x >> shift {
        x -= temporary << shift
        result += 1
      }
      shift -= 2
    }
    return result
  }
}

extension UnsignedInteger {
  // ---------------------------------------------------------------------------
  // MARK: Cube Root
  // ---------------------------------------------------------------------------

  /// Returns the cube root of `x`, rounding toward zero.
  @_transparent // @_inlineable
  public static func cbrt(_ x: Self) -> Self {
    var shift = x.bitWidth - 1
    shift -= shift % 3

    var x = x
    var result = 0 as Self
    while shift >= 0 {
      result *= 2
      let temporary = 3 * result * (result + 1) + 1
      if temporary <= x >> shift {
        x -= temporary << shift
        result += 1
      }
      shift -= 3
    }
    return result
  }

  // ---------------------------------------------------------------------------
  // MARK: Factoring
  // ---------------------------------------------------------------------------

  /// Returns the greatest common divisor of `a` and `b`.
  @_transparent // @_inlineable
  public static func gcd(_ a: Self, _ b: Self) -> Self {
    // An iterative version of Stein's algorithm.
    if a == 0 { return b } // gcd(0, b) == b
    if b == 0 { return a } // gcd(a, 0) == a

    var a = a, b = b, shift = 0 as Self
    while ((a | b) & 1) == 0 {
      a >>= 1
      b >>= 1
      shift += 1
    }
    // Now, shift is equal to log2(k), where k is the greatest power of 2
    // dividing a and b.
    while (a & 1) == 0 { a >>= 1 } // Now, a is odd.
    repeat {
      while (b & 1) == 0 { b >>= 1 } // Now, b is odd.
      if a > b { swap(&a, &b) } // Now, a < b.
      b -= a
    } while b != 0
    // Restore common factors of 2.
    return a << shift
  }

  /// Returns the least common multiple of `a` and `b`.
  @_transparent // @_inlineable
  public static func lcm(_ a: Self, _ b: Self) -> Self {
    if a == 0 || b == 0 { return 0 }
    return a / .gcd(a, b) * b
  }
}

extension UnsignedInteger where Self : FixedWidthInteger {
  // ---------------------------------------------------------------------------
  // MARK: Factoring (Fixed-Width)
  // ---------------------------------------------------------------------------

  /// Returns the least common multiple of `a` and `b` and a flag to indicate
  /// whether overflow occurred during the operation.
  @_transparent // @_inlineable
  public static func lcmReportingOverflow(_ a: Self, _ b: Self)
    -> (partialValue: Self, overflow: Bool) {
    if a == 0 || b == 0 { return (0, false) }
    return (a / .gcd(a, b)).multipliedReportingOverflow(by: b)
  }

  /// Returns the high and low parts of the least common multiple of `a` and `b`
  /// computed using full-width arithmetic.
  @_transparent // @_inlineable
  public static func lcmFullWidth(_ a: Self, _ b: Self)
    -> (high: Self, low: Self.Magnitude) {
    if a == 0 || b == 0 { return (0, 0) }
    return (a / .gcd(a, b)).multipliedFullWidth(by: b)
  }
}

extension BinaryInteger where Magnitude : UnsignedInteger {
  // ---------------------------------------------------------------------------
  // MARK: Cube Root
  // ---------------------------------------------------------------------------

  /// Returns the cube root of `x`, rounding toward zero.
  @_transparent // @_inlineable
  public static func cbrt(_ x: Self) -> Self {
    return x < 0
      ? 0 - Self(Magnitude.cbrt(x.magnitude))
      : Self(Magnitude.cbrt(x.magnitude))
  }

  // ---------------------------------------------------------------------------
  // MARK: Factoring
  // ---------------------------------------------------------------------------

  /// Returns the greatest common divisor of `a` and `b`.
  @_transparent // @_inlineable
  public static func gcd(_ a: Self, _ b: Self) -> Self {
    return Self(Magnitude.gcd(a.magnitude, b.magnitude))
  }

  /// Returns the least common multiple of `a` and `b`.
  @_transparent // @_inlineable
  public static func lcm(_ a: Self, _ b: Self) -> Self {
    return Self(Magnitude.lcm(a.magnitude, b.magnitude))
  }
}

// `BinaryInteger where Self : FixedWidthInteger` may seem superfluous, but it
// is necessary to disambiguate calls to `Magnitude.lcmReportingOverflow(_:_:)`
// and `Magnitude.lcmFullWidth(_:_:)`.
extension BinaryInteger
where Self : FixedWidthInteger,
  Magnitude : FixedWidthInteger & UnsignedInteger,
  Magnitude.Magnitude == Magnitude {
  // ---------------------------------------------------------------------------
  // MARK: Factoring (Fixed-Width)
  // ---------------------------------------------------------------------------

  /// Returns the greatest common divisor of `a` and `b` and a flag to indicate
  /// whether overflow occurred during the operation.
  @_transparent // @_inlineable
  public static func gcdReportingOverflow(_ a: Self, _ b: Self)
    -> (partialValue: Self, overflow: Bool) {
    let t = Self(truncatingIfNeeded: Magnitude.gcd(a.magnitude, b.magnitude))
    return (t, t < 0)
  }

  /// Returns the least common multiple of `a` and `b` and a flag to indicate
  /// whether overflow occurred during the operation.
  @_transparent // @_inlineable
  public static func lcmReportingOverflow(_ a: Self, _ b: Self)
    -> (partialValue: Self, overflow: Bool) {
    let (t, overflow) = Magnitude.lcmReportingOverflow(a.magnitude, b.magnitude)
    let u = Self(truncatingIfNeeded: t)
    return (u, overflow || u < 0)
  }

  /// Returns the high and low parts of the least common multiple of `a` and `b`
  /// computed using full-width arithmetic.
  @_transparent // @_inlineable
  public static func lcmFullWidth(_ a: Self, _ b: Self)
    -> (high: Self, low: Self.Magnitude) {
    let t = Magnitude.lcmFullWidth(a.magnitude, b.magnitude)
    return (Self(t.high), t.low)
  }
}

// =============================================================================
// TIE-BREAKING OPERATORS
//
// The following extensions are required so that an expression such as `2 ** 3`
// is unambiguous as long as `IntegerLiteralType` is one of the standard library
// types below.
// =============================================================================

extension Int {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: Int, rhs: Int) -> Int {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout Int, rhs: Int) {
    lhs = lhs ** rhs
  }
}

extension Int8 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: Int8, rhs: Int8) -> Int8 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout Int8, rhs: Int8) {
    lhs = lhs ** rhs
  }
}

extension Int16 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: Int16, rhs: Int16) -> Int16 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout Int16, rhs: Int16) {
    lhs = lhs ** rhs
  }
}

extension Int32 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: Int32, rhs: Int32) -> Int32 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout Int32, rhs: Int32) {
    lhs = lhs ** rhs
  }
}

extension Int64 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: Int64, rhs: Int64) -> Int64 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout Int64, rhs: Int64) {
    lhs = lhs ** rhs
  }
}

extension UInt {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: UInt, rhs: UInt) -> UInt {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout UInt, rhs: UInt) {
    lhs = lhs ** rhs
  }
}

extension UInt8 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: UInt8, rhs: UInt8) -> UInt8 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout UInt8, rhs: UInt8) {
    lhs = lhs ** rhs
  }
}

extension UInt16 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: UInt16, rhs: UInt16) -> UInt16 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout UInt16, rhs: UInt16) {
    lhs = lhs ** rhs
  }
}

extension UInt32 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: UInt32, rhs: UInt32) -> UInt32 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout UInt32, rhs: UInt32) {
    lhs = lhs ** rhs
  }
}

extension UInt64 {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: UInt64, rhs: UInt64) -> UInt64 {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout UInt64, rhs: UInt64) {
    lhs = lhs ** rhs
  }
}

#if false
extension DoubleWidth {
  /// Returns the result of raising `lhs` to the power of `rhs`, rounded to a
  /// representable value.
  @_transparent // @_inlineable
  public static func ** (lhs: DoubleWidth, rhs: DoubleWidth) -> DoubleWidth {
    return _pow(lhs, rhs)
  }

  /// Raises `lhs` to the power of `rhs` and stores the result in `lhs`, rounded
  /// to a representable value.
  @_transparent // @_inlineable
  public static func **= (lhs: inout DoubleWidth, rhs: DoubleWidth) {
    lhs = lhs ** rhs
  }
}
#endif
