//
//  Bit.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/26/17.
//

/// A type to represent a bit.
@_fixed_layout
/* public */ enum Bit : UInt8 {
  /// The zero bit.
  case zero = 0
  /// The nonzero bit.
  case one = 1

  // TODO: Document this initializer.
  @_transparent
  public init(_ value: UInt8) {
    self = Bit(rawValue: value)!
  }

  // TODO: Document this initializer.
  @_transparent
  public init(_ value: Bool) {
    self = value ? .one : .zero
  }
}

extension Bool {
  // TODO: Document this initializer.
  @_transparent
  /* public */ init(_ value: Bit) {
    self = (value == .one) ? true : false
  }
}

extension Bit {
  // TODO: Document this initializer.
  @_transparent
  public init<Source>(_ source: Source) where Source : BinaryInteger {
    self = Bit(UInt8(source))
  }
}

extension Bit : ExpressibleByIntegerLiteral {
  @_transparent
  public init(integerLiteral value: UInt8) {
    self = Bit(value)
  }
}

extension Bit : CustomStringConvertible {
  @_transparent
  public var description: String {
    return rawValue.description
  }
}

extension Bit: Comparable {
  @_transparent
  public static func < (lhs: Bit, rhs: Bit) -> Bool {
    return lhs == .zero && rhs == .one
  }
}

extension Bit : Numeric {
  public typealias Magnitude = Bit

  @_transparent
  public init?<Source>(exactly source: Source) where Source : BinaryInteger {
    guard source == 0 || source == 1 else { return nil }
    self = Bit(UInt8(source))
  }

  @_transparent
  public var magnitude: Bit { return self }

  @_transparent
  public static func + (lhs: Bit, rhs: Bit) -> Bit {
    return Bit(lhs.rawValue + rhs.rawValue)
  }

  @_transparent
  public static func += (lhs: inout Bit, rhs: Bit) {
    lhs = Bit(lhs.rawValue + rhs.rawValue)
  }

  @_transparent
  public static func - (lhs: Bit, rhs: Bit) -> Bit {
    return Bit(lhs.rawValue - rhs.rawValue)
  }

  @_transparent
  public static func -= (lhs: inout Bit, rhs: Bit) {
    lhs = Bit(lhs.rawValue - rhs.rawValue)
  }

  @_transparent
  public static func * (lhs: Bit, rhs: Bit) -> Bit {
    return Bit(lhs.rawValue * rhs.rawValue)
  }

  @_transparent
  public static func *= (lhs: inout Bit, rhs: Bit) {
    lhs = Bit(lhs.rawValue * rhs.rawValue)
  }
}

extension Bit : FixedWidthInteger {
  public init<U : FloatingPoint>(_ source: U) {
    self = Bit(UInt8(source))
  }

  public init?<U : FloatingPoint>(exactly source: U) {
    guard source == 0 || source == 1 else { return nil }
    self = Bit(UInt8(source))
  }

  public init<U>(_truncatingBits source: U) where U : BinaryInteger {
    self = Bit(UInt8(source & 1))
  }

  public static var isSigned = false

  @_transparent
  public static func / (lhs: Bit, rhs: Bit) -> Bit {
    return Bit(lhs.rawValue / rhs.rawValue)
  }

  @_transparent
  public static func /= (lhs: inout Bit, rhs: Bit) {
    lhs = Bit(lhs.rawValue / rhs.rawValue)
  }

  @_transparent
  public static func % (lhs: Bit, rhs: Bit) -> Bit {
    return Bit(lhs.rawValue % rhs.rawValue)
  }

  @_transparent
  public static func %= (lhs: inout Bit, rhs: Bit) {
    lhs = Bit(lhs.rawValue % rhs.rawValue)
  }

  @_transparent
  public static var bitWidth: Int {
    return 1
  }

  @_transparent
  public static var max: Bit {
    return 1
  }

  @_transparent
  public static var min: Bit {
    return 0
  }

  @_transparent
  public var nonzeroBitCount: Int {
    return self == .zero ? 0 : 1
  }

  @_transparent
  public var leadingZeroBitCount: Int {
    return self == .zero ? 1 : 0
  }

  @_transparent
  public var trailingZeroBitCount: Int {
    return self == .zero ? 1 : 0
  }

  @_transparent
  public func addingReportingOverflow(_ rhs: Bit)
    -> (partialValue: Bit, overflow: ArithmeticOverflow) {
    return self == .one && rhs == .one
      ? (.zero, .overflow)
      : (Bit(rawValue + rhs.rawValue), .none)
  }

  @_transparent
  public func subtractingReportingOverflow(_ rhs: Bit)
    -> (partialValue: Bit, overflow: ArithmeticOverflow) {
    return self == .zero && rhs == .one
      ? (.one, .overflow)
      : (Bit(rawValue - rhs.rawValue), .none)
  }

  @_transparent
  public func multipliedReportingOverflow(by rhs: Bit)
    -> (partialValue: Bit, overflow: ArithmeticOverflow) {
    return (Bit(rawValue * rhs.rawValue), .none)
  }

  @_transparent
  public func dividedReportingOverflow(by rhs: Bit)
    -> (partialValue: Bit, overflow: ArithmeticOverflow) {
    return (Bit(rawValue / rhs.rawValue), .none)
  }

  @_transparent
  public func remainderReportingOverflow(dividingBy rhs: Bit)
    -> (partialValue: Bit, overflow: ArithmeticOverflow) {
    return (Bit(rawValue % rhs.rawValue), .none)
  }

  @_transparent
  public func multipliedFullWidth(by other: Bit) -> (high: Bit, low: Bit) {
    return (.zero, Bit(rawValue * other.rawValue))
  }

  public func dividingFullWidth(_ dividend: (high: Bit, low: Bit))
    -> (quotient: Bit, remainder: Bit) {
    precondition(dividend.high == .zero)
    return (Bit(dividend.low.rawValue / rawValue), .zero)
  }

  // FIXME: The following protocol requirements are subject to changes in Swift.

  public init<U>(bigEndian source: U) where U : BinaryInteger {
    fatalError()
  }

  public init<U>(littleEndian source: U) where U : BinaryInteger {
    fatalError()
  }

  public var bigEndian: Bit {
    fatalError()
  }

  public var littleEndian: Bit {
    fatalError()
  }

  public var byteSwapped: Bit {
    fatalError()
  }

  public func word(at n: Int) -> UInt {
    return rawValue.word(at: n)
  }
}

extension Bit : UnsignedInteger { }
