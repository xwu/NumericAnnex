//
//  Big.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/25/17.
//

/// A type to represent an arbitrary-precision integer.
public struct Big<
  T : FixedWidthInteger & _ExpressibleByBuiltinIntegerLiteral
> where
  T.Magnitude : UnsignedInteger,
  T.Magnitude : FixedWidthInteger,
  T.Magnitude : _ExpressibleByBuiltinIntegerLiteral,
  T.Magnitude.Magnitude == T.Magnitude {
  public typealias Word = T.Magnitude
  
  /// The collection of words in two's complement form, from least significant
  /// to most significant.
  public internal(set) var words: [Word]

  /// Creates a new value with the given words.
  internal init(_ _words: [Word]) {
    precondition(_words.count > 0)
    self.words = _words
  }
}

extension Big {
  // TODO: Document this initializer.
  public init(_ source: T) {
    self.words = [Word(extendingOrTruncating: source)]
  }

  // TODO: Document this initializer.
  public init<U>(_ other: Big<U>) where U.Magnitude == T.Magnitude {
    // If `T` is unsigned, underflow behaves like converting -1 to type `T`.
    if !T.isSigned && U(extendingOrTruncating: other.words.last!) < 0 {
      _ = T(-1)
    }
    self.words = other.words
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
    // We require that `lhs` and `rhs` have words that are canonicalized.
    let count = lhs.words.count
    guard count == rhs.words.count else { return false }
    for i in (0..<count).reversed() {
      if lhs.words[i] != rhs.words[i] { return false }
    }
    return true
  }
}

extension Big : Comparable {
  public static func < (lhs: Big, rhs: Big) -> Bool {
    // We require that `lhs` and `rhs` have words that are canonicalized.
    let lhsWordCount = lhs.words.count
    let rhsWordCount = rhs.words.count
    if lhs._isNegative {
      guard rhs._isNegative else { return true }
      if lhsWordCount < rhsWordCount { return false }
      if lhsWordCount > rhsWordCount { return true }
    } else {
      if rhs._isNegative { return false }
      if lhsWordCount < rhsWordCount { return true }
      if lhsWordCount > rhsWordCount { return false }
    }

    for i in (0..<lhsWordCount).reversed() {
      let l = lhs.words[i]
      let r = rhs.words[i]
      if l < r { return true }
      if l > r { return false }
    }
    return false
  }
}

extension Big : CustomStringConvertible {
  public var description : String {
    if _isNegative {
      return "-\(self._negated().description)"
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
        let bit = words[i] & (1 << Word(width - j - 1)) > 0 ? 1 : 0 as UInt8
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
    return scratch.withUnsafeBufferPointer {
      String(cString: $0.baseAddress!)
    }
  }
}

public typealias BigInt = Big<Int>
public typealias BigUInt = Big<UInt>
