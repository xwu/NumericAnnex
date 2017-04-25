//
//  Factoring.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

extension UnsignedInteger {
  /// Returns the greatest common divisor of `a` and `b`.
  // @_transparent // @_inlineable
  public static func gcd(_ a: Self, _ b: Self) -> Self {
    // An iterative version of Stein's algorithm.
    if a == 0 { return b } // gcd(0, b) == b
    if b == 0 { return a } // gcd(a, 0) == a

    var a = a, b = b, shift = 0 as Self
    while ((a | b) & 1) == 0 {
      a &>>= 1
      b &>>= 1
      shift += 1
    }
    // Now, shift is equal to log2(k), where k is the greatest power of 2
    // dividing a and b.
    while (a & 1) == 0 { a &>>= 1 } // Now, a is odd.
    repeat {
      while (b & 1) == 0 { b &>>= 1 } // Now, b is odd.
      if a > b { swap(&a, &b) } // Now, a < b.
      b -= a
    } while b != 0
    // Restore common factors of 2.
    return a &<< shift
  }

  /// Returns the least common multiple of `a` and `b`.
  @_transparent // @_inlineable
  public static func lcm(_ a: Self, _ b: Self) -> Self {
    if a == 0 || b == 0 { return 0 }
    return a / Self.gcd(a, b) * b
  }
}

extension UnsignedInteger where Self : FixedWidthInteger {
  /// Returns the least common multiple of `a` and `b` and a flag to indicate
  /// whether overflow occurred during the operation.
  // @_transparent // @_inlineable
  public static func lcmReportingOverflow(_ a: Self, _ b: Self)
    -> (partialValue: Self, overflow: ArithmeticOverflow) {
    if a == 0 || b == 0 { return (partialValue: 0, overflow: .none) }
    return (a / Self.gcd(a, b)).multipliedReportingOverflow(by: b)
  }

  /// Returns the high and low parts of the least common multiple of `a` and `b`
  /// computed using full-width arithmetic.
  // @_transparent // @_inlineable
  public static func lcmFullWidth(_ a: Self, _ b: Self)
    -> (high: Self, low: Self.Magnitude) {
    if a == 0 || b == 0 { return (0, 0) }
    return (a / Self.gcd(a, b)).multipliedFullWidth(by: b)
  }
}

extension SignedInteger where Magnitude : UnsignedInteger {
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

extension SignedInteger where Self : FixedWidthInteger,
  Magnitude : FixedWidthInteger & UnsignedInteger,
  Magnitude.Magnitude == Magnitude {
  /// Returns the greatest common divisor of `a` and `b` and a flag to indicate
  /// whether overflow occurred during the operation.
  // @_transparent // @_inlineable
  public static func gcdReportingOverflow(_ a: Self, _ b: Self)
    -> (partialValue: Self, overflow: ArithmeticOverflow) {
    let t = Self(extendingOrTruncating: Magnitude.gcd(a.magnitude, b.magnitude))
    return (
      partialValue: t,
      overflow: ArithmeticOverflow(t < 0)
    )
  }

  /// Returns the least common multiple of `a` and `b` and a flag to indicate
  /// whether overflow occurred during the operation.
  // @_transparent // @_inlineable
  public static func lcmReportingOverflow(_ a: Self, _ b: Self)
    -> (partialValue: Self, overflow: ArithmeticOverflow) {
    let (t, overflow) = Magnitude.lcmReportingOverflow(a.magnitude, b.magnitude)
    let u = Self(extendingOrTruncating: t)
    return (
      partialValue: u,
      overflow: ArithmeticOverflow(overflow == .overflow || u < 0)
    )
  }

  /// Returns the high and low parts of the least common multiple of `a` and `b`
  /// computed using full-width arithmetic.
  // @_transparent // @_inlineable
  public static func lcmFullWidth(_ a: Self, _ b: Self)
    -> (high: Self, low: Self.Magnitude) {
    let t = Magnitude.lcmFullWidth(a.magnitude, b.magnitude)
    return (high: Self(t.high), low: t.low)
  }
}
