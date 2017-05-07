//
//  Big+SignedInteger.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/26/17.
//

extension Big : Numeric {
  internal mutating func _canonicalize() {
    let count = _magnitude.count
    var endIndex = 0
    for i in (0..<count).reversed() {
      if _magnitude[i] != 0 {
        endIndex = i + 1
        break
      }
    }
    _magnitude.removeLast(count - endIndex)
    if endIndex == 0 { _sign = .plus }
  }

  internal static func _addAssignMagnitude(
    _ lhs: inout Big, offset lhsDigitOffset: Int = 0,
    _ rhs: Big, offset rhsDigitOffset: Int = 0
  ) {
    let lhsDigitCount = lhs._magnitude.count - lhsDigitOffset
    let rhsDigitCount = rhs._magnitude.count - rhsDigitOffset
    let commonDigitCount = Swift.min(lhsDigitCount, rhsDigitCount)
    var carry = false
    for i in 0..<commonDigitCount {
      var r = rhs._magnitude[i + rhsDigitOffset]
      if carry {
        if r == Digit.max {
          // carry == true
          continue
        }
        r += 1
      }
      let index = i + lhsDigitOffset
      let overflow: ArithmeticOverflow
      (lhs._magnitude[index], overflow) =
        lhs._magnitude[index].addingReportingOverflow(r)
      carry = (overflow == .overflow)
    }
    if lhsDigitCount < rhsDigitCount {
      lhs._magnitude.reserveCapacity(rhsDigitCount + lhsDigitOffset)
      for i in commonDigitCount..<rhsDigitCount {
        var r = rhs._magnitude[i + rhsDigitOffset]
        if carry {
          if r == Digit.max {
            lhs._magnitude.append(0)
            // carry == true
            continue
          }
          r += 1
        }
        lhs._magnitude.append(r)
        carry = false
      }
    } else if lhsDigitCount > rhsDigitCount {
      if carry {
        for i in commonDigitCount..<lhsDigitCount {
          let index = i + lhsDigitOffset
          if lhs._magnitude[index] == Digit.max {
            lhs._magnitude[index] = 0
            // carry == true
            continue
          }
          lhs._magnitude[index] += 1
          carry = false
          break
        }
      }
    }
    if carry {
      lhs._magnitude.append(1)
    }
  }

  /// The result of this operation is not canonicalized and the sign of zero may
  /// be negative.
  internal static func _subtractAssignMagnitude(
    _ lhs: inout Big, offset lhsDigitOffset: Int = 0,
    _ rhs: Big, offset rhsDigitOffset: Int = 0
  ) {
    let lhsDigitCount = lhs._magnitude.count - lhsDigitOffset
    let rhsDigitCount = rhs._magnitude.count - rhsDigitOffset
    let commonDigitCount = Swift.min(lhsDigitCount, rhsDigitCount)
    var borrow = false
    for i in 0..<commonDigitCount {
      var r = rhs._magnitude[i + rhsDigitOffset]
      if borrow {
        if r == Digit.max {
          // borrow == true
          continue
        }
        r += 1
      }
      let index = i + lhsDigitOffset
      let overflow: ArithmeticOverflow
      (lhs._magnitude[index], overflow) =
        lhs._magnitude[index].subtractingReportingOverflow(r)
      borrow = (overflow == .overflow)
    }
    if lhsDigitCount < rhsDigitCount {
      lhs._magnitude.reserveCapacity(rhsDigitCount + lhsDigitOffset)
      for i in commonDigitCount..<rhsDigitCount {
        var r = rhs._magnitude[i + rhsDigitOffset]
        if !borrow {
          if r == 0 {
            lhs._magnitude.append(0)
            // borrow == false
            continue
          }
          r -= 1
        }
        lhs._magnitude.append(Digit.max - r)
        borrow = true
      }
    } else if lhsDigitCount > rhsDigitCount {
      if borrow {
        for i in commonDigitCount..<lhsDigitCount {
          let index = i + lhsDigitOffset
          if lhs._magnitude[index] == 0 {
            lhs._magnitude[index] = Digit.max
            // borrow == true
            continue
          }
          lhs._magnitude[index] -= 1
          borrow = false
          break
        }
      }
    }
    if borrow {
      lhs._sign = lhs._sign == .minus ? .plus : .minus
      let count = lhs._magnitude.count
      outer: for i in 0..<count {
        let overflow: ArithmeticOverflow
        (lhs._magnitude[i], overflow) =
          (~lhs._magnitude[i]).addingReportingOverflow(1)
        if overflow == .none {
          inner: for j in (i + 1)..<count {
            lhs._magnitude[j] = ~lhs._magnitude[j]
          }
          break outer
        }
      }
    }
  }

  /// The result of this operation is not canonicalized.
  internal static func _multiplyMagnitude(
    _ lhs: Big, range lhsDigitRange: CountableRange<Int>? = nil,
    _ rhs: Big, range rhsDigitRange: CountableRange<Int>? = nil
  ) -> Big {
    let lhsDigitOffset = lhsDigitRange?.startIndex ?? 0
    let rhsDigitOffset = rhsDigitRange?.startIndex ?? 0
    let lhsDigitCount = lhsDigitRange?.count ?? lhs._magnitude.count
    let rhsDigitCount = rhsDigitRange?.count ?? rhs._magnitude.count
    var digits = [Digit](repeating: 0, count: lhsDigitCount + rhsDigitCount)

    var outerCarry = 0 as Digit
    for outerIndex in 0..<rhsDigitCount {
      let digit = rhs._magnitude[outerIndex + rhsDigitOffset]
      var offset = outerIndex
      var overflow: ArithmeticOverflow

      var innerCarry = 0 as Digit
      for innerIndex in 0..<lhsDigitCount {
        var high: Digit
        let low: Digit
        (high, low) =
          lhs._magnitude[innerIndex + lhsDigitOffset]
            .multipliedFullWidth(by: digit)
        (digits[offset], overflow) =
          digits[offset].addingReportingOverflow(low)
        if overflow == .overflow { innerCarry += 1 }

        offset += 1
        (high, overflow) = high.addingReportingOverflow(innerCarry)
        innerCarry = (overflow == .overflow) ? 1 : 0
        (digits[offset], overflow) =
          digits[offset].addingReportingOverflow(high)
        if overflow == .overflow { innerCarry += 1 }
      }
      (digits[offset], overflow) =
        digits[offset].addingReportingOverflow(outerCarry)
      outerCarry = (overflow == .overflow) ? innerCarry + 1 : innerCarry
    }
    return Big(_magnitude: digits)
  }

  public init?<U>(exactly source: U) where U : BinaryInteger {
    self.init(source)
  }

  public var magnitude: Big {
    return _sign == .minus ? Big(_magnitude: _magnitude) : self
  }

  @_transparent // @_inlineable
  public static func + (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func += (lhs: inout Big, rhs: Big) {
    defer { lhs._canonicalize() }

    switch (lhs._sign, rhs._sign) {
    case (.plus, .plus):
      fallthrough
    case (.minus, .minus):
      _addAssignMagnitude(&lhs, rhs)
    case (.plus, .minus):
      fallthrough
    case (.minus, .plus):
      _subtractAssignMagnitude(&lhs, rhs)
    }
  }

  @_transparent // @_inlineable
  public static func - (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }

  public static func -= (lhs: inout Big, rhs: Big) {
    defer { lhs._canonicalize() }

    switch (lhs._sign, rhs._sign) {
    case (.plus, .plus):
      fallthrough
    case (.minus, .minus):
      _subtractAssignMagnitude(&lhs, rhs)
    case (.plus, .minus):
      fallthrough
    case (.minus, .plus):
      _addAssignMagnitude(&lhs, rhs)
    }
  }

  // @_transparent // @_inlineable
  public static func * (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }

  public static func *= (lhs: inout Big, rhs: Big) {
    defer { lhs._canonicalize() }

    lhs = _multiplyMagnitude(lhs, rhs)
    if lhs._sign != rhs._sign { lhs._sign = .minus }
  }
}

extension Big : SignedNumeric {
  // @_transparent // @_inlineable
  public static prefix func - (rhs: Big) -> Big {
    var rhs = rhs
    rhs.negate()
    return rhs
  }

  // @_transparent // @_inlineable
  public mutating func negate() {
    _sign = _sign == .minus || _magnitude.isEmpty ? .plus : .minus
  }
}

extension Big : BinaryInteger {
  @_transparent // @_inlineable
  public static var isSigned: Bool { return true }

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
    return 1 + _magnitude.count * Digit.bitWidth -
      (_magnitude.last ?? Digit.max).leadingZeroBitCount
  }

  public var trailingZeroBitCount: Int {
    // The trailing zero bit count of the two's complement representation of a
    // negative value is equal to the trailing zero bit count of the binary
    // representation of the magnitude.
    for i in 0..<_magnitude.count {
      if _magnitude[i] != 0 {
        return i * Digit.bitWidth + _magnitude[i].trailingZeroBitCount
      }
    }
    return 1
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
    return -(rhs + 1)
  }

  // @_transparent // @_inlineable
  public static func & (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }

  public static func &= (lhs: inout Big, rhs: Big) {
    fatalError()
    /*
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
    */
  }

  // @_transparent // @_inlineable
  public static func | (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }

  public static func |= (lhs: inout Big, rhs: Big) {
    fatalError()
    /*
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
    */
  }

  // @_transparent // @_inlineable
  public static func ^ (lhs: Big, rhs: Big) -> Big {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }

  public static func ^= (lhs: inout Big, rhs: Big) {
    fatalError()
    /*
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
    */
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
    if _sign == .minus { return -1 }
    if _magnitude.isEmpty { return 0 }
    return 1
  }

  public func word(at n: Int) -> UInt {
    // TODO: Implement (or, eventually, remove).
    fatalError()
  }
}

extension Big : SignedInteger { }

extension Big {
  // TODO: Implement and document this method.
  public static func pow(
    _ base: Big, _ exponent: Big, modulo modulus: Big
  ) -> Big {
    fatalError()
  }

  // TODO: Document this method.
  public func inverse(modulo modulus: Big) -> Big {
    var rhs = self
    rhs.invert(modulo: modulus)
    return rhs
  }

  // TODO: Implement and document this method.
  public mutating func invert(modulo modulus: Big) {
    fatalError()
  }

  // TODO: Document this method.
  public func multiplied(by other: Big, modulo modulus: Big) -> Big {
    var lhs = self
    lhs.multiply(by: other, modulo: modulus)
    return lhs
  }

  // TODO: Implement and document this method.
  public mutating func multiply(by other: Big, modulo modulus: Big) {
    fatalError()
  }
}
