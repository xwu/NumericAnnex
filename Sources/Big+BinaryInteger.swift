//
//  Big+BinaryInteger.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/26/17.
//

/*
extension Big : Numeric {
  public init?<U>(exactly source: U) where U : BinaryInteger {
    self.init(source)
  }

  public var magnitude: Big<T.Magnitude> {
    return Big<T.Magnitude>(
      T.isSigned && _storage._msb == .one ? ~self + 1 : self
    )
  }

  @_transparent // @_inlineable
  public static func + (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func += (lhs: inout Big, rhs: Big) {
    let lwc = lhs._storage._words.count
    let rwc = rhs._storage._words.count
    let common = Swift.min(lwc, rwc)
    var carry = false
    for i in 0..<common {
      var r = rhs._storage._words[i]
      if carry {
        if r == Words<T>.Word.max {
          // carry == true
          continue
        }
        r += 1
      }
      let ov: ArithmeticOverflow
      (lhs._storage._words[i], ov) =
        lhs._storage._words[i].addingReportingOverflow(r)
      carry = (ov == .overflow)
    }
    if lwc < rwc {
      lhs._storage._words.reserveCapacity(rwc)
      if T.isSigned && lhs._storage._msb == .one {
        for i in common..<rwc {
          var r = rhs._storage._words[i]
          if !carry {
            if r == 0 {
              lhs._storage._words.append(Words<T>.Word.max)
              // carry == false
              continue
            }
            r -= 1
          }
          lhs._storage._words.append(r)
          carry = true
        }
      } else {
        for i in common..<rwc {
          var r = rhs._storage._words[i]
          if carry {
            if r == Words<T>.Word.max {
              lhs._storage._words.append(0)
              // carry == true
              continue
            }
            r += 1
          }
          lhs._storage._words.append(r)
          carry = false
        }
      }
    } else if lwc > rwc {
      if T.isSigned && rhs._storage._msb == .one {
        if !carry {
          for i in common..<lwc {
            if lhs._storage._words[i] == 0 {
              lhs._storage._words[i] = Words<T>.Word.max
              // carry == false
              continue
            }
            lhs._storage._words[i] -= 1
            carry = true
            break
          }
        }
      } else if carry {
        for i in common..<lwc {
          if lhs._storage._words[i] == Words<T>.Word.max {
            lhs._storage._words[i] = 0
            // carry == true
            continue
          }
          lhs._storage._words[i] += 1
          carry = false
          break
        }
      }
    }
    guard T.isSigned else {
      if carry { lhs._storage._words.append(1) }
      return
    }
    if lhs._storage._msb != rhs._storage._msb {
      lhs._storage._msb = carry ? .zero : .one
      lhs._storage._canonicalize()
    } else if carry && lhs._storage._msb == .zero {
      lhs._storage._words.append(1)
    } else if !carry && lhs._storage._msb == .one {
      lhs._storage._words.append(Words<T>.Word.max - 1)
    }
  }

  @_transparent // @_inlineable
  public static func - (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }

  public static func -= (lhs: inout Big, rhs: Big) {
    let lwc = lhs._storage._words.count
    let rwc = rhs._storage._words.count
    let common = Swift.min(lwc, rwc)
    var borrow = false
    for i in 0..<common {
      var r = rhs._storage._words[i]
      if borrow {
        if r == Words<T>.Word.max {
          // borrow == true
          continue
        }
        r += 1
      }
      let ov: ArithmeticOverflow
      (lhs._storage._words[i], ov) =
        lhs._storage._words[i].subtractingReportingOverflow(r)
      borrow = (ov == .overflow)
    }
    if lwc < rwc {
      lhs._storage._words.reserveCapacity(rwc)
      if T.isSigned && lhs._storage._msb == .one {
        for i in common..<rwc {
          let r = rhs._storage._words[i]
          if !borrow {
            lhs._storage._words.append(Words<T>.Word.max - r)
            // borrow == false
            continue
          } else if r == Words<T>.Word.max {
            lhs._storage._words.append(Words<T>.Word.max)
            // borrow == true
            continue
          }
          lhs._storage._words.append(Words<T>.Word.max - r - 1)
          borrow = false
        }
      } else {
        for i in common..<rwc {
          let r = rhs._storage._words[i]
          if borrow {
            lhs._storage._words.append(Words<T>.Word.max - r)
            // borrow == true
            continue
          } else if r == 0 {
            lhs._storage._words.append(0)
            // borrow == false
            continue
          }
          lhs._storage._words.append(Words<T>.Word.max - r + 1)
          borrow = true
        }
      }
    } else if lwc > rwc {
      if T.isSigned && rhs._storage._msb == .one {
        for i in common..<lwc {
          if borrow { break }
          if lhs._storage._words[i] == Words<T>.Word.max {
            lhs._storage._words[i] = 0
            // borrow == false
            continue
          }
          lhs._storage._words[i] += 1
          borrow = true
        }
      } else {
        for i in common..<lwc {
          if !borrow { break }
          if lhs._storage._words[i] == 0 {
            lhs._storage._words[i] = Words<T>.Word.max
            // borrow == true
            continue
          }
          lhs._storage._words[i] -= 1
          borrow = false
        }
      }
    }
    guard T.isSigned else {
      if borrow { _ = T(-1) }
      lhs._storage._canonicalize()
      return
    }
    if lhs._storage._msb == rhs._storage._msb {
      lhs._storage._msb = borrow ? .one : .zero
      lhs._storage._canonicalize()
    } else if borrow && lhs._storage._msb == .one {
      lhs._storage._words.append(Words<T>.Word.max - 1)
    } else if !borrow && lhs._storage._msb == .zero {
      lhs._storage._words.append(1)
    }
  }

  @_transparent // @_inlineable
  public static func * (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }

  public static func *= (lhs: inout Big, rhs: Big) {
    // Note that here we use _storage directly.
    let lwc = lhs._storage.count
    if lwc == 1 { return }
    let rwc = rhs._storage.count
    if rwc == 1 { lhs._storage._words = []; return }

    var words = Array<Words<T>.Word>(repeating: 0, count: (lwc + rwc))
    var msw = 0 as Words<T>.Word
    for i in 0..<rwc {
      var carry = 0 as Words<T>.Word
      for j in 0..<lwc {
        var high: Words<T>.Word
        let low: Words<T>.Word
        (high, low) = lhs._storage[j].multipliedFullWidth(by: rhs._storage[i])
        var offset = i + j
        var ov: ArithmeticOverflow
        (words[offset], ov) = words[offset].addingReportingOverflow(low)
        if ov == .overflow { carry += 1 }
        (high, ov) = high.addingReportingOverflow(carry)
        carry = 0
        if ov == .overflow { carry += 1 }
        offset += 1
        (words[offset], ov) = words[offset].addingReportingOverflow(high)
        if ov == .overflow { carry += 1 }
      }
      let offset = i + lwc
      let ov: ArithmeticOverflow
      (words[offset], ov) = words[offset].addingReportingOverflow(msw)
      msw = carry
      if ov == .overflow { msw += 1 }
    }
    if T.isSigned {
      lhs._storage._msb = words[lwc + rwc - 2] & 1 == 1 ? .one : .zero
    }
    words.removeLast(2)
    lhs._storage._words = words
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
    return Words<T>.Word.bitWidth * _storage.count
  }

  public var trailingZeroBitCount: Int {
    for i in 0..<_storage.count {
      guard _storage[i] != 0 else { continue }
      return _storage[i].trailingZeroBitCount + i * Words<T>.Word.bitWidth
    }
    return 0
  }

  public static prefix func ~ (rhs: Big) -> Big {
    var words = rhs._storage._words
    for i in 0..<words.count {
      words[i] = ~words[i]
    }
    return Big(Words(
      _msb: T.isSigned && rhs._storage._msb == .one ? .zero : .one,
      words: words
    ))
  }

  @_transparent // @_inlineable
  public static func & (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }

  public static func &= (lhs: inout Big, rhs: Big) {
    let lwc = lhs._storage._words.count
    let rwc = rhs._storage._words.count
    let common = min(lwc, rwc)
    for i in 0..<common {
      lhs._storage._words[i] &= rhs._storage._words[i]
    }
    if (!T.isSigned || rhs._storage._msb == .zero) && lwc > rwc {
      lhs._storage._words.removeSubrange(common..<lwc)
    } else if (T.isSigned && lhs._storage._msb == .one) && lwc < rwc {
      lhs._storage._words.reserveCapacity(rwc)
      lhs._storage._words.append(contentsOf: rhs._storage._words[common..<rwc])
    }
    if T.isSigned {
      lhs._storage._msb =
        Bit(lhs._storage._msb.rawValue & rhs._storage._msb.rawValue)
    }
  }

  @_transparent // @_inlineable
  public static func | (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }

  public static func |= (lhs: inout Big, rhs: Big) {
    let lwc = lhs._storage._words.count
    let rwc = rhs._storage._words.count
    let common = min(lwc, rwc)
    for i in 0..<common {
      lhs._storage._words[i] |= rhs._storage._words[i]
    }
    if (!T.isSigned || lhs._storage._msb == .zero) && lwc < rwc {
      lhs._storage._words.reserveCapacity(rwc)
      lhs._storage._words.append(contentsOf: rhs._storage._words[common..<rwc])
    } else if (T.isSigned && rhs._storage._msb == .one) && lwc > rwc {
      lhs._storage._words.replaceSubrange(
        common..<lwc,
        with: repeatElement(Words<T>.Word.max, count: lwc - common)
      )
    }
    if T.isSigned {
      lhs._storage._msb =
        Bit(lhs._storage._msb.rawValue | rhs._storage._msb.rawValue)
    }
  }

  @_transparent // @_inlineable
  public static func ^ (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }

  public static func ^= (lhs: inout Big, rhs: Big) {
    let lwc = lhs._storage._words.count
    let rwc = rhs._storage._words.count
    let common = min(lwc, rwc)
    for i in 0..<common {
      lhs._storage._words[i] ^= rhs._storage._words[i]
    }
    if lwc < rwc {
      lhs._storage._words.reserveCapacity(rwc)
      if !T.isSigned || lhs._storage._msb == .zero {
        lhs._storage._words.append(
          contentsOf: rhs._storage._words[common..<rwc]
        )
      } else {
        lhs._storage._words.append(
          contentsOf: rhs._storage._words[common..<rwc].lazy.map { ~$0 }
        )
      }
    } else if (T.isSigned && rhs._storage._msb == .one) && lwc > rwc {
      for i in common..<lwc {
        lhs._storage._words[i] = ~lhs._storage._words[i]
      }
    }
    if T.isSigned {
      lhs._storage._msb =
        Bit(lhs._storage._msb.rawValue ^ rhs._storage._msb.rawValue)
    }
  }

  public func signum() -> Big {
    if T.isSigned && _storage._msb == .one { return -1 }
    if _storage._words.count == 0 { return 0 }
    return 1
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

extension Big /* : UnsignedInteger */ where T : UnsignedInteger { }
*/
