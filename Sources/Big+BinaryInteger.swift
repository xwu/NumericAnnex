//
//  Big+BinaryInteger.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/26/17.
//

extension Big {
  /// A Boolean value indicating whether the instance is negative.
  internal var _isNegative: Bool {
    return T.isSigned && T(extendingOrTruncating: words.last!) < 0
  }

  internal mutating func _canonicalize() {
    guard let last = words.last,
      last == 0 || (T.isSigned && last == Word.max) else { return }

    let old = words.count
    var new = 1
    for i in (0..<(old - 1)).reversed() {
      let word = words[i]
      if word != last {
        if T.isSigned
          && (T(extendingOrTruncating: word) < 0)
            != (T(extendingOrTruncating: last) < 0) {
          new = i + 2
        } else {
          new = i + 1
        }
        break
      }
    }
    words.removeLast(old - new)
  }

  internal func _negated() -> Big {
    var rhs = self
    rhs._negate()
    return rhs
  }

  internal mutating func _negate() {
    for i in 0..<words.count {
      words[i] = ~words[i]
    }
    self += 1
  }

  internal static func _longMultiply<U>(_ lhs: U, _ rhs: U) -> [Word]
    where U : RandomAccessCollection, U.Iterator.Element == Word,
      U.Index == Int, U.IndexDistance == Int {
    let lcount = lhs.count
    let rcount = rhs.count
    var words = [Word](repeating: 0, count: lcount + rcount)
    var icarry = 0 as Word
    for i in 0..<rcount {
      let rword = rhs[i]
      var jcarry = 0 as Word
      for j in 0..<lcount {
        var high: Word
        let low: Word
        (high, low) = lhs[j].multipliedFullWidth(by: rword)
        let offset = i + j
        var overflow: ArithmeticOverflow
        (words[offset], overflow) = words[offset].addingReportingOverflow(low)
        if overflow == .overflow { jcarry += 1 }
        (high, overflow) = high.addingReportingOverflow(jcarry)
        jcarry = (overflow == .overflow) ? 1 : 0
        (words[offset + 1], overflow) =
          words[offset + 1].addingReportingOverflow(high)
        if overflow == .overflow { jcarry += 1 }
      }
      let offset = i + lcount
      let overflow: ArithmeticOverflow
      (words[offset], overflow) =
        words[offset].addingReportingOverflow(icarry)
      icarry = (overflow == .overflow) ? jcarry + 1 : jcarry
    }
    return words
  }
}

extension Big : Numeric {
  public init?<U>(exactly source: U) where U : BinaryInteger {
    self.init(source)
  }

  public var magnitude: Big<T.Magnitude> {
    return Big<T.Magnitude>(_isNegative ? _negated() : self)
  }

  @_transparent // @_inlineable
  public static func + (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func += (lhs: inout Big, rhs: Big) {
    let lnegative = lhs._isNegative

    let lcount = lhs.words.count
    let rcount = rhs.words.count
    let common = min(lcount, rcount)
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
      let overflow: ArithmeticOverflow
      (lhs.words[i], overflow) = lhs.words[i].addingReportingOverflow(r)
      carry = (overflow == .overflow)
    }
    if lcount < rcount {
      lhs.words.reserveCapacity(rcount)
      if lhs._isNegative {
        for i in common..<rcount {
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
        for i in common..<rcount {
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
    } else if lcount > rcount {
      if rhs._isNegative {
        if !carry {
          for i in common..<lcount {
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
        for i in common..<lcount {
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

    let rnegative = rhs._isNegative
    if lnegative && rnegative && !lhs._isNegative {
      lhs.words.append(Word.max)
    } else if !lnegative && !rnegative && lhs._isNegative {
      lhs.words.append(0)
    } else {
      lhs._canonicalize()
    }
  }

  @_transparent // @_inlineable
  public static func - (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }

  public static func -= (lhs: inout Big, rhs: Big) {
    let lnegative = lhs._isNegative

    let lcount = lhs.words.count
    let rcount = rhs.words.count
    let common = min(lcount, rcount)
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
      let overflow: ArithmeticOverflow
      (lhs.words[i], overflow) = lhs.words[i].subtractingReportingOverflow(r)
      borrow = (overflow == .overflow)
    }
    if lcount < rcount {
      lhs.words.reserveCapacity(rcount)
      if lhs._isNegative {
        for i in common..<rcount {
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
        for i in common..<rcount {
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
    } else if lcount > rcount {
      if rhs._isNegative {
        for i in common..<lcount {
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
        for i in common..<lcount {
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
      // If `T` is unsigned, underflow behaves like converting -1 to type `T`.
      if borrow { _ = T(-1) }
      lhs._canonicalize()
      return
    }

    let rnegative = rhs._isNegative
    if lnegative && !rnegative && !lhs._isNegative {
      lhs.words.append(Word.max)
    } else if !lnegative && rnegative && lhs._isNegative {
      lhs.words.append(0)
    } else {
      lhs._canonicalize()
    }
  }

  @_transparent // @_inlineable
  public static func * (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }

  public static func *= (lhs: inout Big, rhs: Big) {
    let lnegative = lhs._isNegative
    if lnegative { lhs._negate() }
    let rnegative = rhs._isNegative
    let rhs = rnegative ? rhs._negated() : rhs

    if lhs.words.count == 1 && rhs.words.count == 1 {
      let (high, low) = lhs.words.last!.multipliedFullWidth(by: rhs.words.last!)
      lhs.words = [low, high]
    } else {
      lhs.words = _longMultiply(lhs.words, rhs.words)
    }
    lhs._canonicalize()

    if lnegative != rnegative { lhs._negate() }
  }
}

extension Big /* : BinaryInteger */ {
  @_transparent // @_inlineable
  public static var isSigned: Bool {
    return T.isSigned
  }

  public init?<U : FloatingPoint>(exactly source: U) {
    fatalError()
  }

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
    return Word.bitWidth * words.count
  }

  public var trailingZeroBitCount: Int {
    for i in 0..<words.count {
      guard words[i] != 0 else { continue }
      return words[i].trailingZeroBitCount + i * Word.bitWidth
    }
    return bitWidth
  }

  // TODO: Implement `/`, `/=`, `%`, `%=`.

  public static prefix func ~ (rhs: Big) -> Big {
    var words = rhs.words
    for i in 0..<words.count {
      words[i] = ~words[i]
    }
    return Big(words)
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
    if !rhs._isNegative && lwc > rwc {
      lhs.words.removeSubrange(common..<lwc)
    } else if lhs._isNegative && lwc < rwc {
      lhs.words.reserveCapacity(rwc)
      lhs.words.append(contentsOf: rhs.words[common..<rwc])
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
    if !lhs._isNegative && lwc < rwc {
      lhs.words.reserveCapacity(rwc)
      lhs.words.append(contentsOf: rhs.words[common..<rwc])
    } else if rhs._isNegative && lwc > rwc {
      lhs.words.replaceSubrange(
        common..<lwc, with: repeatElement(Word.max, count: lwc - common)
      )
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
      if !lhs._isNegative {
        lhs.words.append(contentsOf: rhs.words[common..<rwc])
      } else {
        lhs.words.append(contentsOf: rhs.words[common..<rwc].lazy.map { ~$0 })
      }
    } else if rhs._isNegative && lwc > rwc {
      for i in common..<lwc {
        lhs.words[i] = ~lhs.words[i]
      }
    }
  }

  // TODO: Implement `&<<`, `&<<=`, `&>>`, `&>>=`.

  public func signum() -> Big {
    if _isNegative { return -1 }
    if words.last! == 0 { return 0 }
    return 1
  }
}

extension Big /* : SignedInteger */ where T : SignedInteger {
  public static prefix func - (lhs: Big) -> Big {
    return lhs._negated()
  }

  public mutating func negate() {
    _negate()
  }
}

extension Big /* : UnsignedInteger */ where T : UnsignedInteger { }
