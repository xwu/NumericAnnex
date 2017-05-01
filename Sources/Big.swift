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
  /// A type that represents a 'limb' in the representation of the value.
  public typealias Limb = T.Magnitude

  /// The mathematical sign of the value.
  internal var _sign: Sign

  /// The collection of 'limbs' in the magnitude of the value, from least
  /// significant to most significant.
  internal var _limbs: [Limb]

  /// Creates a new value with the given sign and magnitude.
  internal init(_sign: Sign = .plus, _limbs: [Limb] = []) {
    self._sign = _sign
    self._limbs = _limbs
  }
}

extension Big {
  public init(_ source: T) {
    self._sign = source < 0 ? .minus : .plus
    self._limbs = source == 0 ? [] : [source.magnitude]
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
    guard _limbs.count > 1 else {
      let description = _limbs.last?.description ?? "0"
      return _sign == .minus ? "-\(description)" : description
    }
    
    // A version of the "double dabble" algorithm.
    let width = Limb.bitWidth
    var count = width * _limbs.count / 3
    var min = count - 2
    var scratch = [UInt8](repeating: 0, count: count)
    // Traverse from most significant to least significant word.
    for i in (0..<_limbs.count).reversed() {
      for j in 0..<width {
        // Bit to be shifted in.
        let bit =
          _limbs[i] & (1 << Limb(width - j - 1)) > 0 ? 1 : 0 as UInt8
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
    guard lhs._sign == rhs._sign else { return false }
    guard lhs._limbs.count == rhs._limbs.count else { return false }
    return lhs._limbs == rhs._limbs
  }
}

extension Big : Hashable {
  public var hashValue: Int {
    // TODO: Implement.
    fatalError()
  }
}

extension Big : Comparable {
  internal static func _compareMagnitude(_ lhs: Big, _ rhs: Big) -> Int {
    let lhsLimbCount = lhs._limbs.count
    let rhsLimbCount = rhs._limbs.count
    if lhsLimbCount > rhsLimbCount { return 1 }
    if lhsLimbCount < rhsLimbCount { return -1 }
    for i in (0..<lhsLimbCount).reversed() {
      let l = lhs._limbs[i]
      let r = rhs._limbs[i]
      if l > r { return 1 }
      if l < r { return -1 }
    }
    return 0
  }

  public static func < (lhs: Big, rhs: Big) -> Bool {
    switch (lhs._sign, rhs._sign) {
    case (.plus, .plus):
      return _compareMagnitude(lhs, rhs) == -1
    case (.minus, .minus):
      return _compareMagnitude(lhs, rhs) == 1
    case (.plus, .minus):
      return false
    case (.minus, .plus):
      return true
    }
  }
}

extension Big : Strideable {
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
