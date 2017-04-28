//
//  Big.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/25/17.
//

public struct Big<
  T : FixedWidthInteger & _ExpressibleByBuiltinIntegerLiteral
> where
  T.Magnitude : UnsignedInteger,
  T.Magnitude : FixedWidthInteger,
  T.Magnitude : _ExpressibleByBuiltinIntegerLiteral,
  T.Magnitude.Magnitude == T.Magnitude {
  public typealias Word = T.Magnitude

  internal var _storage: _Storage<T>

  internal init(_ _storage: _Storage<T>) {
    self._storage = _storage
  }
}

extension Big {
  public init(_ source: T) {
    var s = _Storage<T>()
    s._highest = source
    self._storage = s
  }

  public init<U>(_ other: Big<U>) where U.Magnitude == T.Magnitude {
    if !T.isSigned && other._storage._highest < 0 { _ = T(-1) }
    self._storage = _Storage(bitPattern: other._storage)
  }
}

extension Big : ExpressibleByIntegerLiteral {
  @_transparent // @_inlineable
  public init(integerLiteral value: T) {
    self.init(value)
  }
}

extension Big : Equatable {
  public static func == (lhs: Big, rhs: Big) -> Bool {
    let limit = max(lhs._storage.count, rhs._storage.count)
    for i in (0..<limit).reversed() {
      if lhs._storage[i] != rhs._storage[i] { return false }
    }
    return true
  }
}

/*
extension Big : Comparable {
  public static func < (lhs: Big, rhs: Big) -> Bool {
    let limit: Int
    if T.isSigned {
      let l = lhs._storage._msb
      let r = rhs._storage._msb
      if l > r { return true }
      if l < r { return false }
      limit = max(lhs._storage.count, rhs._storage.count) - 1
    } else {
      limit = max(lhs._storage.count, rhs._storage.count)
    }
    for i in (0..<limit).reversed() {
      let l = lhs._storage[i]
      let r = rhs._storage[i]
      if l < r { return true }
      if l > r { return false }
    }
    return false
  }
}
*/

extension Big : CustomStringConvertible {
  public var description : String {
    // FIXME: Mathematical operators are not yet defined.
    /*
    if T.isSigned && _storage._highest < 0 {
      return "-\((~self + 1).description)"
    }
    */

    // A version of the "double dabble" algorithm.
    let width = Word.bitWidth
    var count = width * _storage.count / 3
    var min = count - 2
    var scratch = [UInt8](repeating: 0, count: count)
    // Traverse from most significant to least significant word.
    for i in (0..<_storage.count).reversed() {
      for j in 0..<width {
        // Bit to be shifted in.
        let bit = _storage[i] & (1 << Word(width - j - 1)) > 0 ? 1 : 0 as UInt8
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

public typealias BigInt = Big<Int>
public typealias BigUInt = Big<UInt>
