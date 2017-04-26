//
//  Big.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/25/17.
//

@_fixed_layout
internal enum _Bit : Int {
  case zero = 0
  case one = 1
}

public struct Big<
  T : FixedWidthInteger & _ExpressibleByBuiltinIntegerLiteral
> where T.Magnitude == UInt {

  internal var _sign: _Bit
  public internal(set) var words: [UInt]

  internal init(_sign: _Bit = .zero, words: [UInt] = []) {
    self._sign = _sign
    self.words = words
  }
}

extension Big {
  public init<U>(_ value: Big<U>) {
    if !T.isSigned && value._sign == .one {
      _ = T(-1)
    }
    self._sign = value._sign
    self.words = value.words
  }
}

extension Big : ExpressibleByIntegerLiteral {
  public init(integerLiteral value: T) {
    self._sign = value < 0 ? .one : .zero
    self.words = value == 0 ? [] : [value.magnitude]
  }
}

extension Big : Equatable {
  public static func == (lhs: Big, rhs: Big) -> Bool {
    // FIXME: Canonical representation of values is assumed.
    // Either assert or relax this assumption.
    if T.isSigned && lhs._sign != rhs._sign { return false }
    if lhs.words.count != rhs.words.count { return false }
    return lhs.words.elementsEqual(rhs.words)
  }
}

extension Big {
  internal mutating func _canonicalize() {
    let count = words.count
    var start = 0
    for i in (0..<count).reversed() {
      if words[i] != 0 {
        start = i + 1
        break
      }
    }
    words.removeSubrange(start..<count)
    if T.isSigned && words.count == 0 {
      _sign = .zero
    }
  }
}

extension Big /* : Numeric */ {
  public var magnitude: Big<T.Magnitude> {
    return Big<T.Magnitude>(T.isSigned && _sign == .one ? 0 - self : self)
  }

  @_transparent // @_inlineable
  public static func + (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func += (lhs: inout Big, rhs: Big) {
    let lwc = lhs.words.count
    let rwc = rhs.words.count
    let common = Swift.min(lwc, rwc)
    var carry = false
    for i in 0..<common {
      var r = rhs.words[i]
      if carry {
        if r == UInt.max {
          // carry == true
          continue
        }
        r += 1
      }
      let ov: ArithmeticOverflow
      (lhs.words[i], ov) = lhs.words[i].addingReportingOverflow(r)
      carry = (ov == .overflow)
    }
    if lwc < rwc {
      lhs.words.reserveCapacity(rwc)
      if T.isSigned && lhs._sign == .one {
        for i in common..<rwc {
          var r = rhs.words[i]
          if !carry {
            if r == 0 {
              lhs.words.append(UInt.max)
              // carry == false
              continue
            }
            r -= 1
          }
          lhs.words.append(r)
          carry = true
        }
      } else {
        for i in common..<rwc {
          var r = rhs.words[i]
          if carry {
            if r == UInt.max {
              lhs.words.append(0)
              // carry == true
              continue
            }
            r += 1
          }
          lhs.words.append(r)
          carry = false
        }
      }
    } else if lwc > rwc {
      if T.isSigned && rhs._sign == .one {
        if !carry {
          for i in common..<lwc {
            if lhs.words[i] == 0 {
              lhs.words[i] = UInt.max
              // carry == false
              continue
            }
            lhs.words[i] -= 1
            carry = true
            break
          }
        }
      } else if carry {
        for i in common..<lwc {
          if lhs.words[i] == UInt.max {
            lhs.words[i] = 0
            // carry == true
            continue
          }
          lhs.words[i] += 1
          carry = false
          break
        }
      }
    }
    guard T.isSigned else {
      if carry { lhs.words.append(1) }
      return
    }
    if lhs._sign != rhs._sign {
      lhs._sign = carry ? .zero : .one
      lhs._canonicalize()
    } else if carry {
      lhs.words.append(lhs._sign == .one ? UInt.max - 1 : 1)
    }
  }

  @_transparent // @_inlineable
  public static func - (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }

  public static func -= (lhs: inout Big, rhs: Big) {
    let lwc = lhs.words.count
    let rwc = rhs.words.count
    let common = Swift.min(lwc, rwc)
    var borrow = false
    for i in 0..<common {
      var r = rhs.words[i]
      if borrow {
        if r == UInt.max {
          // borrow == true
          continue
        }
        r += 1
      }
      let ov: ArithmeticOverflow
      (lhs.words[i], ov) = lhs.words[i].subtractingReportingOverflow(r)
      borrow = (ov == .overflow)
    }
    if lwc < rwc {
      lhs.words.reserveCapacity(rwc)
      if T.isSigned && lhs._sign == .one {
        for i in common..<rwc {
          let r = rhs.words[i]
          if !borrow {
            lhs.words.append(UInt.max - r)
            // borrow == false
            continue
          } else if r == UInt.max {
            lhs.words.append(UInt.max)
            // borrow == true
            continue
          }
          lhs.words.append(UInt.max - r - 1)
          borrow = false
        }
      } else {
        for i in common..<rwc {
          let r = rhs.words[i]
          if borrow {
            lhs.words.append(UInt.max - r)
            // borrow == true
            continue
          } else if r == 0 {
            lhs.words.append(0)
            // borrow == false
            continue
          }
          lhs.words.append(UInt.max - r + 1)
          borrow = true
        }
      }
    } else if lwc > rwc {
      if T.isSigned && rhs._sign == .one {
        for i in common..<lwc {
          if borrow { break }
          if lhs.words[i] == UInt.max {
            lhs.words[i] = 0
            // borrow == false
            continue
          }
          lhs.words[i] += 1
          borrow = true
        }
      } else {
        for i in common..<lwc {
          if !borrow { break }
          if lhs.words[i] == 0 {
            lhs.words[i] = UInt.max
            // borrow == true
            continue
          }
          lhs.words[i] -= 1
          borrow = false
        }
      }
    }
    guard T.isSigned else {
      if !borrow { _ = T(-1) }
      lhs._canonicalize()
      return
    }
    if lhs._sign == rhs._sign {
      lhs._sign = borrow ? .zero : .one
      lhs._canonicalize()
    } else if borrow {
      lhs.words.append(lhs._sign == .one ? UInt.max - 1 : 1)
    }
  }
}

extension Big /* : BinaryInteger */ {
  @_transparent // @_inlineable
  public static var isSigned: Bool {
    return T.isSigned
  }
/*
  public init?<U : FloatingPoint>(exactly source: U) {
    fatalError()
  }
*/
  public init<U : FloatingPoint>(_ source: U) {
    fatalError()
  }

  public init<U : BinaryInteger>(_ source: U) {
    fatalError()
  }

  public init<U : BinaryInteger>(extendingOrTruncating source: U) {
    fatalError()
  }

  public init<U : BinaryInteger>(clamping source: U) {
    fatalError()
  }

  public var bitWidth: Int {
    return UInt.bitWidth * words.count + (T.isSigned ? 1 : 0)
  }

  public var trailingZeroBitCount: Int {
    for i in 0..<words.count {
      guard words[i] != 0 else { continue }
      return words[i].trailingZeroBitCount + i * UInt.bitWidth
    }
    return T.isSigned ? 1 : 0
  }

  public static prefix func ~ (rhs: Big) -> Big {
    var words = rhs.words
    for i in 0..<words.count {
      words[i] = ~words[i]
    }
    return Big(
      _sign: T.isSigned && rhs._sign == .one ? .zero : .one,
      words: words
    )
  }

  @_transparent // @_inlineable
  public static func & (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }

  public static func &= (lhs: inout Big, rhs: Big) {
    let lwc = lhs.words.count
    let rwc = rhs.words.count
    let common = min(lwc, rwc)
    for i in 0..<common {
      lhs.words[i] &= rhs.words[i]
    }
    if (!T.isSigned || rhs._sign == .zero) && lwc > rwc {
      lhs.words.removeSubrange(common..<lwc)
    } else if (T.isSigned && lhs._sign == .one) && lwc < rwc {
      lhs.words.reserveCapacity(rwc)
      lhs.words.append(contentsOf: rhs.words[common..<rwc])
    }
    if T.isSigned {
      lhs._sign = _Bit(rawValue: lhs._sign.rawValue & rhs._sign.rawValue)!
    }
  }

  @_transparent // @_inlineable
  public static func | (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }

  public static func |= (lhs: inout Big, rhs: Big) {
    let lwc = lhs.words.count
    let rwc = rhs.words.count
    let common = min(lwc, rwc)
    for i in 0..<common {
      lhs.words[i] |= rhs.words[i]
    }
    if (!T.isSigned || lhs._sign == .zero) && lwc < rwc {
      lhs.words.reserveCapacity(rwc)
      lhs.words.append(contentsOf: rhs.words[common..<rwc])
    } else if (T.isSigned && rhs._sign == .one) && lwc > rwc {
      lhs.words.replaceSubrange(
        common..<lwc,
        with: repeatElement(UInt.max, count: lwc - common)
      )
    }
    if T.isSigned {
      lhs._sign = _Bit(rawValue: lhs._sign.rawValue | rhs._sign.rawValue)!
    }
  }

  @_transparent // @_inlineable
  public static func ^ (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }

  public static func ^= (lhs: inout Big, rhs: Big) {
    let lwc = lhs.words.count
    let rwc = rhs.words.count
    let common = min(lwc, rwc)
    for i in 0..<common {
      lhs.words[i] ^= rhs.words[i]
    }
    if lwc < rwc {
      lhs.words.reserveCapacity(rwc)
      if !T.isSigned || lhs._sign == .zero {
        lhs.words.append(contentsOf: rhs.words[common..<rwc])
      } else {
        lhs.words.append(contentsOf: rhs.words[common..<rwc].lazy.map { ~$0 })
      }
    } else if (T.isSigned && rhs._sign == .one) && lwc > rwc {
      for i in common..<lwc {
        lhs.words[i] = ~lhs.words[i]
      }
    }
    if T.isSigned {
      lhs._sign = _Bit(rawValue: lhs._sign.rawValue ^ rhs._sign.rawValue)!
    }
  }

  public func signum() -> Big {
    if words.count == 0 { return 0 }
    return T.isSigned && _sign == .one ? -1 : 1
  }
}

extension Big /* : SignedInteger */ where T : SignedInteger {

}

extension Big /* : UnsignedInteger */ where T : UnsignedInteger {

}
