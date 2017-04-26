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
  public typealias Word = T.Magnitude

  internal var _sign: _Bit
  public internal(set) var words: [Word]

  internal init(_sign: _Bit = .zero, words: [Word] = []) {
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

  public init(_ value: T) {
    self._sign = value < 0 ? .one : .zero
    self.words = value == 0 ? [] : [value.magnitude]
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

extension Big : CustomStringConvertible {
  public var description : String {
    if words.count == 0 { return "0" }
    if T.isSigned && _sign == .one {
      return "-\((~self + 1).description)"
    }
    // A version of the "double dabble" algorithm.
    let width = Word.bitWidth
    var count = width * words.count / 3
    var min = count - 2
    var scratch = [UInt8](repeating: 0, count: count)
    // Traverse from most significant to least significant word.
    for i in (0..<words.count).reversed() {
      for j in 0..<width {
        // Bit to be shifted in.
        let bit = (words[i] & (1 << Word(width - j - 1)) > 0 ? 1 : 0 as UInt8)
        // Increment any binary-coded decimal greater than four by three.
        for k in min..<count {
          scratch[k] += scratch[k] >= 5 ? 3 : 0
        }
        // Shift scratch to the left.
        if scratch[min] >= 8 { min -= 1 }
        for k in min..<(count - 1) {
          scratch[k] &<<= 1
          scratch[k] &= 0xF
          scratch[k] |= (scratch[k + 1] >= 8) ? 1 : 0
        }
        // Shift in the new bit.
        scratch[count - 1] &<<= 1
        scratch[count - 1] &= 0xF
        scratch[count - 1] |= bit
      }
    }
    // Remove leading zeros.
    let i = scratch.index { $0 != 0 } ?? 0
    scratch.removeSubrange(0..<i)
    count -= i
    // Convert from binary-coded decimal to NUL-terminated ASCII.
    for i in 0..<count {
      scratch[i] += 48 // "0"
    }
    scratch.append(0)
    return scratch.withUnsafeBufferPointer {
      String(cString: $0.baseAddress!)
    }
  }
}

extension Big {
  internal mutating func _canonicalize() {
    let query = T.isSigned && _sign == .one ? Word.max : 0
    let count = words.count
    var start = 0
    for i in (0..<count).reversed() {
      if words[i] != query {
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
        if r == Word.max {
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
              lhs.words.append(Word.max)
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
            if r == Word.max {
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
              lhs.words[i] = Word.max
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
          if lhs.words[i] == Word.max {
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
    } else if carry && lhs._sign == .zero {
      lhs.words.append(1)
    } else if !carry && lhs._sign == .one {
      lhs.words.append(Word.max - 1)
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
        if r == Word.max {
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
            lhs.words.append(Word.max - r)
            // borrow == false
            continue
          } else if r == Word.max {
            lhs.words.append(Word.max)
            // borrow == true
            continue
          }
          lhs.words.append(Word.max - r - 1)
          borrow = false
        }
      } else {
        for i in common..<rwc {
          let r = rhs.words[i]
          if borrow {
            lhs.words.append(Word.max - r)
            // borrow == true
            continue
          } else if r == 0 {
            lhs.words.append(0)
            // borrow == false
            continue
          }
          lhs.words.append(Word.max - r + 1)
          borrow = true
        }
      }
    } else if lwc > rwc {
      if T.isSigned && rhs._sign == .one {
        for i in common..<lwc {
          if borrow { break }
          if lhs.words[i] == Word.max {
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
            lhs.words[i] = Word.max
            // borrow == true
            continue
          }
          lhs.words[i] -= 1
          borrow = false
        }
      }
    }
    guard T.isSigned else {
      if borrow { _ = T(-1) }
      lhs._canonicalize()
      return
    }
    if lhs._sign == rhs._sign {
      lhs._sign = borrow ? .one : .zero
      lhs._canonicalize()
    } else if borrow && lhs._sign == .one {
      lhs.words.append(Word.max - 1)
    } else if !borrow && lhs._sign == .zero {
      lhs.words.append(1)
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
    return Word.bitWidth * words.count + (T.isSigned ? 1 : 0)
  }

  public var trailingZeroBitCount: Int {
    for i in 0..<words.count {
      guard words[i] != 0 else { continue }
      return words[i].trailingZeroBitCount + i * Word.bitWidth
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
        with: repeatElement(Word.max, count: lwc - common)
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
  public static prefix func - (lhs: Big) -> Big {
    return ~lhs + 1
  }

  public mutating func negate() {
    self = ~self
    self += 1
  }
}

extension Big /* : UnsignedInteger */ where T : UnsignedInteger {

}

public typealias BigInt = Big<Int>
public typealias BigUInt = Big<UInt>
