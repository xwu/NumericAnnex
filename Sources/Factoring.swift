//
//  Factoring.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/15/17.
//

extension _UnsignedInteger {
  /// The greatest common denominator of `a` and `b`.
  public static func gcd(_ a: Self, _ b: Self) -> Self {
    if a == 0 { return b } // gcd(0, b) == b
    if b == 0 { return a } // gcd(a, 0) == a

    var a = a, b = b, shift = 0 as Self

    while ((a | b) & 1) == 0 {
      a >>= 1
      b >>= 1
      shift += 1 as Self
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

  /// The lowest common multiple of `a` and `b`.
  public static func lcm(_ a: Self, _ b: Self) -> Self {
    if a == 0 || b == 0 { return 0 }
    return a / Self.gcd(a, b) * b
  }
}

// -----------------------------------------------------------------------------
// FIXME: Remove the following protocols after new integer protocols are landed
// -----------------------------------------------------------------------------
public protocol _Integer : Integer {
  associatedtype Magnitude : Equatable, ExpressibleByIntegerLiteral, Comparable
  var magnitude: Magnitude { get }
  init(_: Magnitude)

  static func >> (_: Self, _: Self) -> Self
  static func << (_: Self, _: Self) -> Self
  static func >>= (_: inout Self, _: Self)
  static func <<= (_: inout Self, _: Self)
}

public protocol _UnsignedInteger : _Integer, UnsignedInteger { }

extension UInt : _UnsignedInteger {
  public var magnitude: UInt { return self }
}

extension UInt8 : _UnsignedInteger {
  public var magnitude: UInt8 { return self }
}

extension UInt16 : _UnsignedInteger {
  public var magnitude: UInt16 { return self }
}

extension UInt32 : _UnsignedInteger {
  public var magnitude: UInt32 { return self }
}

extension UInt64 : _UnsignedInteger {
  public var magnitude: UInt64 { return self }
}

public protocol _SignedInteger : _Integer, SignedInteger {
  mutating func negate()
}

extension _SignedInteger {
  public mutating func negate() {
    self = 0 - self
  }
}

extension Int : _SignedInteger {
  public var magnitude: UInt {
    let base = UInt(bitPattern: self)
    return self < 0 ? ~base + 1 : base
  }
}

extension Int8 : _SignedInteger {
  public var magnitude: UInt8 {
    let base = UInt8(bitPattern: self)
    return self < 0 ? ~base + 1 : base
  }
}

extension Int16 : _SignedInteger {
  public var magnitude: UInt16 {
    let base = UInt16(bitPattern: self)
    return self < 0 ? ~base + 1 : base
  }
}

extension Int32 : _SignedInteger {
  public var magnitude: UInt32 {
    let base = UInt32(bitPattern: self)
    return self < 0 ? ~base + 1 : base
  }
}

extension Int64 : _SignedInteger {
  public var magnitude: UInt64 {
    let base = UInt64(bitPattern: self)
    return self < 0 ? ~base + 1 : base
  }
}
