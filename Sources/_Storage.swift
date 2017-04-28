//
//  _Storage.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/26/17.
//

@_fixed_layout
public struct _Storage <
  T : FixedWidthInteger
> where T.Magnitude : FixedWidthInteger & UnsignedInteger {
  public typealias Word = T.Magnitude

  internal var _words: [Word]
  internal var _highest: T

  internal init(_ _words: [Word]) {
    self._words = _words
    self._highest = T(extendingOrTruncating: self._words.popLast() ?? Word())
  }
}

extension _Storage {
  public init<U>(bitPattern other: _Storage<U>)
    where U.Magnitude == T.Magnitude {
    self._words = other._words
    self._highest = T(extendingOrTruncating: other._highest)
  }
}

extension _Storage
  : RandomAccessCollection, MutableCollection, RangeReplaceableCollection {
  @_transparent
  public init() {
    self._words = []
    self._highest = T(extendingOrTruncating: Word())
  }

  @_transparent
  public var startIndex: Int {
    return 0
  }

  @_transparent
  public var endIndex: Int {
    return _words.count + 1
  }

  @_transparent
  public func index(before i: Int) -> Int {
    return i - 1
  }

  @_transparent
  public func index(after i: Int) -> Int {
    return i + 1
  }

  internal mutating func _canonicalize() {
    let test = Word(extendingOrTruncating: _highest)
    guard test == 0 || T.isSigned && test == Word.max else { return }
    let count = _words.count
    var start = 0
    for i in (0..<count).reversed() {
      if _words[i] != test {
        start = i + 1
        break
      }
    }
    _words.removeLast(count - start)
    // Replace `_highest`, unless we need to keep the current value because it
    // has the sign bit.
    if let last = _words.last {
      let test = T(extendingOrTruncating: last)
      if T.isSigned && (_highest < 0) != (test < 0) { return }
      _highest = test
    }
  }

  public mutating func replaceSubrange<C>(
    _ subrange: Range<Int>, with newElements: C
  ) where C : Collection, C.Iterator.Element == Word {
    let count = _words.count
    if subrange.upperBound <= count {
      _words.replaceSubrange(subrange, with: newElements)
      return
    }
    _words.reserveCapacity(subrange.upperBound)
    if subrange.lowerBound > count {
      _words.append(Word(extendingOrTruncating: _highest))
      let fill = repeatElement(
        T.isSigned && _highest < 0 ? Word.max : 0,
        count: subrange.lowerBound - _words.count
      )
      _words.append(contentsOf: fill)
    } else if subrange.lowerBound < count {
      _words.removeLast(count - subrange.lowerBound)
    }
    _words.append(contentsOf: newElements)
    _highest = T(extendingOrTruncating: _words.popLast() ?? Word())
    _canonicalize()
  }

  public mutating func reserveCapacity(_ n: Int) {
    _words.reserveCapacity(n)
  }

  public subscript(_noncanonicalizing position: Int) -> Word {
    get {
      return self[position]
    }
    set {
      let count = _words.count
      if position < count {
        _words[position] = newValue
        return
      }
      if position > count {
        _words.reserveCapacity(position /* + 1 */)
        // We need only `position` elements because we never append `newValue`
        // to `_words`. Ordinarily, we append all values and then determine if
        // one should be popped to be stored as `_highest`, and therefore we
        // reserve capacity for one more element than the expected final count.
        // Here, we'll reserve only what we need.
        _words.append(Word(extendingOrTruncating: _highest))
        let fill = repeatElement(
          T.isSigned && _highest < 0 ? Word.max : 0,
          count: position - _words.count
        )
        _words.append(contentsOf: fill)
      }
      _highest = T(extendingOrTruncating: newValue)
    }
  }

  public subscript(position: Int) -> Word {
    get {
      let count = _words.count
      if position < count {
        return _words[position]
      }
      if position == count {
        return Word(extendingOrTruncating: _highest)
      }
      return T.isSigned && _highest < 0 ? Word.max : 0
    }
    set {
      self[_noncanonicalizing: position] = newValue
      _canonicalize()
    }
  }

  public subscript(bounds: Range<Int>)
    -> MutableRangeReplaceableRandomAccessSlice<_Storage<T>> {
    get {
      return MutableRangeReplaceableRandomAccessSlice(
        base: self, bounds: bounds
      )
    }
    set {
      replaceSubrange(bounds, with: newValue)
    }
  }
}
