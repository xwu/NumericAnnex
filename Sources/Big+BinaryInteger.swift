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
    let lhsIsNegative = lhs._isNegative
    let rhsIsNegative = rhs._isNegative

    let lhsWordCount = lhs.words.count
    let rhsWordCount = rhs.words.count
    let common = min(lhsWordCount, rhsWordCount)
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
    if lhsWordCount < rhsWordCount {
      lhs.words.reserveCapacity(rhsWordCount)
      if lhsIsNegative {
        for i in common..<rhsWordCount {
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
        for i in common..<rhsWordCount {
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
    } else if lhsWordCount > rhsWordCount {
      if rhsIsNegative {
        if !carry {
          for i in common..<lhsWordCount {
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
        for i in common..<lhsWordCount {
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
    if lhsIsNegative && rhsIsNegative && !lhs._isNegative {
      lhs.words.append(Word.max)
    } else if !lhsIsNegative && !rhsIsNegative && lhs._isNegative {
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
    let lhsIsNegative = lhs._isNegative
    let rhsIsNegative = rhs._isNegative

    let lhsWordCount = lhs.words.count
    let rhsWordCount = rhs.words.count
    let common = min(lhsWordCount, rhsWordCount)
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
    if lhsWordCount < rhsWordCount {
      lhs.words.reserveCapacity(rhsWordCount)
      if lhsIsNegative {
        for i in common..<rhsWordCount {
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
        for i in common..<rhsWordCount {
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
    } else if lhsWordCount > rhsWordCount {
      if rhsIsNegative {
        for i in common..<lhsWordCount {
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
        for i in common..<lhsWordCount {
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
    if lhsIsNegative && !rhsIsNegative && !lhs._isNegative {
      lhs.words.append(Word.max)
    } else if !lhsIsNegative && rhsIsNegative && lhs._isNegative {
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
    let lhsWordCount = lhs.words.count
    let rhsWordCount = rhs.words.count
    if lhsWordCount == 1 {
      let word = lhs.words.last!
      if word == 0 {
        lhs.words = [0]
        return
      }
      if rhsWordCount == 1 {
        let (high, low) = word.multipliedFullWidth(by: rhs.words.last!)
        lhs.words = [low, high]
        lhs._canonicalize()
        return
      }
    }
    if rhsWordCount == 1 && rhs.words.last! == 0 {
      lhs.words = [0]
      return
    }

    let lhsIsNegative = lhs._isNegative
    if lhsIsNegative { lhs._negate() }
    let rhsIsNegative = rhs._isNegative
    let rhs = rhsIsNegative ? rhs._negated() : rhs

    var words = [Word](repeating: 0, count: lhsWordCount + rhsWordCount)
    var outerCarry = 0 as Word
    for outerIndex in 0..<rhsWordCount {
      let word = rhs.words[outerIndex]
      var innerCarry = 0 as Word
      for innerIndex in 0..<lhsWordCount {
        var high: Word
        let low: Word
        (high, low) = lhs.words[innerIndex].multipliedFullWidth(by: word)
        let offset = outerIndex + innerIndex
        var overflow: ArithmeticOverflow
        (words[offset], overflow) = words[offset].addingReportingOverflow(low)
        if overflow == .overflow { innerCarry += 1 }
        (high, overflow) = high.addingReportingOverflow(innerCarry)
        innerCarry = (overflow == .overflow) ? 1 : 0
        (words[offset + 1], overflow) =
          words[offset + 1].addingReportingOverflow(high)
        if overflow == .overflow { innerCarry += 1 }
      }
      let offset = outerIndex + lhsWordCount
      let overflow: ArithmeticOverflow
      (words[offset], overflow) =
        words[offset].addingReportingOverflow(outerCarry)
      outerCarry = (overflow == .overflow) ? innerCarry + 1 : innerCarry
    }
    lhs.words = words

    if lhsIsNegative != rhsIsNegative { lhs._negate() }
    lhs._canonicalize()
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
    if !T.isSigned && source < 0 {
      self.init(0 as U)
    } else {
      self.init(source)
    }
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

  public static func / (_ lhs: Big, _ rhs: Big) -> Big {
    var lhs = lhs
    lhs /= rhs
    return rhs
  }

  public static func /= (_ lhs: inout Big, _ rhs: Big) {
    // TODO: Implement division.
    fatalError()
  }

  public static func % (_ lhs: Big, _ rhs: Big) -> Big {
    var lhs = lhs
    lhs %= rhs
    return rhs
  }

  public static func %= (_ lhs: inout Big, _ rhs: Big) {
    // TODO: Implement remainder.
    fatalError()
  }

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
    let lhsIsNegative = lhs._isNegative
    let rhsIsNegative = rhs._isNegative
    let lhsWordCount = lhs.words.count
    let rhsWordCount = rhs.words.count
    let common = min(lhsWordCount, rhsWordCount)
    for i in 0..<common {
      lhs.words[i] &= rhs.words[i]
    }
    if !rhsIsNegative && lhsWordCount > rhsWordCount {
      lhs.words.removeSubrange(common..<lhsWordCount)
    } else if lhsIsNegative && lhsWordCount < rhsWordCount {
      lhs.words.reserveCapacity(rhsWordCount)
      lhs.words.append(contentsOf: rhs.words[common..<rhsWordCount])
    }
  }

  @_transparent // @_inlineable
  public static func | (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }

  public static func |= (lhs: inout Big, rhs: Big) {
    let lhsIsNegative = lhs._isNegative
    let rhsIsNegative = rhs._isNegative
    let lhsWordCount = lhs.words.count
    let rhsWordCount = rhs.words.count
    let common = min(lhsWordCount, rhsWordCount)
    for i in 0..<common {
      lhs.words[i] |= rhs.words[i]
    }
    if !lhsIsNegative && lhsWordCount < rhsWordCount {
      lhs.words.reserveCapacity(rhsWordCount)
      lhs.words.append(contentsOf: rhs.words[common..<rhsWordCount])
    } else if rhsIsNegative && lhsWordCount > rhsWordCount {
      lhs.words.replaceSubrange(
        common..<lhsWordCount,
        with: repeatElement(Word.max, count: lhsWordCount - common)
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
    let lhsIsNegative = lhs._isNegative
    let rhsIsNegative = rhs._isNegative
    let lhsWordCount = lhs.words.count
    let rhsWordCount = rhs.words.count
    let common = min(lhsWordCount, rhsWordCount)
    for i in 0..<common {
      lhs.words[i] ^= rhs.words[i]
    }
    if lhsWordCount < rhsWordCount {
      lhs.words.reserveCapacity(rhsWordCount)
      if !lhsIsNegative {
        lhs.words.append(contentsOf: rhs.words[common..<rhsWordCount])
      } else {
        lhs.words.append(
          contentsOf: rhs.words[common..<rhsWordCount].lazy.map { ~$0 }
        )
      }
    } else if rhsIsNegative && lhsWordCount > rhsWordCount {
      for i in common..<lhsWordCount {
        lhs.words[i] = ~lhs.words[i]
      }
    }
  }

  public static func &<< (_ lhs: Big, _ rhs: Big) -> Big {
    fatalError()
  }

  public static func &<<= (_ lhs: inout Big, _ rhs: Big) {
    fatalError()
  }

  public static func &>> (_ lhs: Big, _ rhs: Big) -> Big {
    fatalError()
  }

  public static func &>>= (_ lhs: inout Big, _ rhs: Big) {
    fatalError()
  }

  public func signum() -> Big {
    if _isNegative { return -1 }
    if words.last! == 0 { return 0 }
    return 1
  }

  public func word(at n: Int) -> UInt {
    // TODO: Implement (or, eventually, remove).
    fatalError()
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
