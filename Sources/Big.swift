//
//  Big.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/25/17.
//

/// A type to represent an arbitrary-precision integer.
/* public */ struct Big<T : FixedWidthInteger & SignedInteger>
where T : _ExpressibleByBuiltinIntegerLiteral,
T.Magnitude : FixedWidthInteger & UnsignedInteger,
T.Magnitude : _ExpressibleByBuiltinIntegerLiteral,
T.Magnitude.Magnitude == T.Magnitude {
  /// The type that represents a digit in the representation of the value.
  public typealias Digit = T.Magnitude

  /// The mathematical sign of the value.
  internal var _sign: Sign

  /// The collection of digits in the magnitude of the value, from least
  /// significant to most significant.
  internal var _magnitude: [Digit]

  /// Creates a new value with the given sign and magnitude.
  internal init(_sign: Sign = .plus, _magnitude: [Digit] = []) {
    self._sign = _sign
    self._magnitude = _magnitude
  }
}

extension Big {
  public init(_ source: T) {
    self._sign = source < 0 ? .minus : .plus
    self._magnitude = source == 0 ? [] : [source.magnitude]
  }
}

extension Big {
  internal static func _compareMagnitude(_ lhs: Big, _ rhs: Big) -> Int {
    let lhsDigitCount = lhs._magnitude.count
    let rhsDigitCount = rhs._magnitude.count
    if lhsDigitCount < rhsDigitCount { return -1 }
    if lhsDigitCount > rhsDigitCount { return 1 }
    for i in (0..<lhsDigitCount).reversed() {
      let l = lhs._magnitude[i]
      let r = rhs._magnitude[i]
      if l < r { return -1 }
      if l > r { return 1 }
    }
    return 0
  }
}

extension Big : ExpressibleByIntegerLiteral {
  @_transparent // @_inlineable
  public init(integerLiteral value: T) {
    self.init(value)
  }
}

extension Big : CustomStringConvertible {
  public var description : String {
    guard _magnitude.count > 1 else {
      let description = _magnitude.last?.description ?? "0"
      return _sign == .minus ? "-\(description)" : description
    }
    
    // A version of the "double dabble" algorithm.
    let width = Digit.bitWidth
    var count = width * _magnitude.count / 3
    var min = count - 2
    var scratch = [UInt8](repeating: 0, count: count)
    // Traverse from most significant to least significant word.
    for i in (0..<_magnitude.count).reversed() {
      for j in 0..<width {
        // Bit to be shifted in.
        let bit =
          _magnitude[i] & (1 << Digit(width - j - 1)) > 0 ? 1 : 0 as UInt8
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
    scratch.removeFirst(i)
    count -= i
    // Convert from binary-coded decimal to NUL-terminated ASCII.
    for i in 0..<count {
      scratch[i] += 48 // "0"
    }
    scratch.append(0)
    let description = scratch.withUnsafeBufferPointer {
      String(cString: $0.baseAddress!)
    }
    return _sign == .minus ? "-\(description)" : description
  }
}

extension Big : Equatable {
  public static func == (lhs: Big, rhs: Big) -> Bool {
    return lhs._sign == rhs._sign && _compareMagnitude(lhs, rhs) == 0
  }
}

extension Big : Hashable {
  public var hashValue: Int {
    // TODO: Implement.
    fatalError()
  }
}

extension Big : Comparable {
  public static func < (lhs: Big, rhs: Big) -> Bool {
    switch (lhs._sign, rhs._sign) {
    case (.plus, .minus):
      return false
    case (.minus, .plus):
      return true
    case (.plus, .plus):
      return _compareMagnitude(lhs, rhs) < 0
    case (.minus, .minus):
      return _compareMagnitude(lhs, rhs) > 0
    }
  }
}

extension Big : Strideable, _Strideable {
  @_transparent // @_inlineable
  public func distance(to other: Big) -> Big {
    return other - self
  }

  @_transparent // @_inlineable
  public func advanced(by amount: Big) -> Big {
    return self + amount
  }
}

/* public */ typealias BigInt = Big<Int>
