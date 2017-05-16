//
//  PRNG.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/15/17.
//

/// A pseudo-random number generator.
/* public */ protocol PRNG : class, IteratorProtocol, Sequence
where Element : FixedWidthInteger & UnsignedInteger, SubSequence : Sequence,
  Element == Iterator.Element, Element == SubSequence.Iterator.Element {
  /// A type that can represent the internal state of the pseudo-random number
  /// generator.
  associatedtype State

  /// The maximum value that may be generated by the pseudo-random number
  /// generator.
  static var max: Element { get }

  /// The minimum value that may be generated by the pseudo-random number
  /// generator.
  static var min: Element { get }

  /// The internal state of the pseudo-random number generator.
  var state: State { get set }

  /// Creates a pseudo-random number generator with the given internal state.
  ///
  /// - Parameters:
  ///   - state: The value to be used as the generator's internal state.
  init(state: State)

  /// Creates a pseudo-random number generator with an internal state seeded
  /// using cryptographically secure random bytes.
  ///
  /// If cryptographically secure random bytes are unavailable, the result is
  /// `nil`.
  init?()
}

extension PRNG {
  public static var max: Element { return Element.max }

  public static var min: Element { return Element.min }

  // TODO: Document this method.
  // @_versioned
  internal static var _maxRandomBitCount: Int {
    let difference = Self.max - Self.min
    guard difference < Element.max else { return Element.bitWidth }
    return Element.bitWidth - (difference + 1).leadingZeroBitCount - 1
  }
}

// TODO: Document methods in this extension.
extension PRNG {
  // @_versioned
  internal func _random<T : FixedWidthInteger & UnsignedInteger>(
    _: T.Type = T.self, bitCount: Int = T.bitWidth
  ) -> T {
    let maxRandomBitCount = Self._maxRandomBitCount
    let bitCount = Swift.min(bitCount, T.bitWidth)
    if T.bitWidth == Element.bitWidth &&
      maxRandomBitCount == Element.bitWidth &&
      bitCount == T.bitWidth {
      // It is an awkward way of spelling `next()`, but it is necessary.
      guard let next = first(where: { _ in true }) else { fatalError() }
      return T(extendingOrTruncating: next)
    }

    let (quotient, remainder) =
      bitCount.quotientAndRemainder(dividingBy: maxRandomBitCount)
    let max =
      (Element.max &>> (Element.bitWidth - Self._maxRandomBitCount)) + Self.min
    var temporary = 0 as T
    // Call `next()` at least `quotient` times.
    for i in 0..<quotient {
      guard let next = first(where: { $0 <= max }) else { fatalError() }
      temporary +=
        T(extendingOrTruncating: next) &<< (maxRandomBitCount * i)
    }
    // If `remainder != 0`, call `next()` at least one more time.
    if remainder != 0 {
      guard let next = first(where: { $0 <= max }) else { fatalError() }
      let mask = Element.max &>> (Element.bitWidth - remainder)
      temporary +=
        T(extendingOrTruncating: next & mask) &<< (maxRandomBitCount * quotient)
    }
    return temporary
  }

  public func uniform<T : FixedWidthInteger & UnsignedInteger>(
    _: T.Type = T.self, a: T, b: T
  ) -> T {
    precondition(
      b >= a,
      "Discrete uniform distribution parameter b should not be less than a"
    )
    guard a != b else { return a }

    let difference = b - a
    guard difference < T.max else {
      return _random() + a
    }
    let bitCount = T.bitWidth - difference.leadingZeroBitCount
    var temporary: T
    repeat {
      temporary = _random(bitCount: bitCount)
    } while temporary > difference
    return temporary + a
  }

  @_transparent // @_inlineable
  public func uniform<T : FixedWidthInteger & UnsignedInteger>(
    _: T.Type = T.self
  ) -> T {
    return uniform(a: T.min, b: T.max)
  }

  @_transparent // @_inlineable
  public func uniform<T : FixedWidthInteger & UnsignedInteger>(
    _: T.Type = T.self, a: T, b: T, count: Int
  ) -> UnfoldSequence<T, Int> {
    precondition(count >= 0, "Element count should be non-negative")
    return sequence(state: 0) { (state: inout Int) -> T? in
      defer { state += 1 }
      return state == count ? nil : self.uniform(a: a, b: b)
    }
  }

  @_transparent // @_inlineable
  public func uniform<T : FixedWidthInteger & UnsignedInteger>(
    _: T.Type = T.self, count: Int
  ) -> UnfoldSequence<T, Int> {
    return uniform(a: T.min, b: T.max, count: count)
  }

  public func uniform<T : FixedWidthInteger & SignedInteger>(
    _: T.Type = T.self, a: T, b: T
  ) -> T where T.Magnitude : FixedWidthInteger & UnsignedInteger {
    precondition(
      b >= a,
      "Discrete uniform distribution parameter b should not be less than a"
    )
    guard a != b else { return a }

    let test = a.signum() < 0
    let difference = test
      ? (b.signum() < 0 ? a.magnitude - b.magnitude : b.magnitude + a.magnitude)
      : b.magnitude - a.magnitude
    guard difference < T.Magnitude.max else {
      return test ? T(_random() - a.magnitude) : T(_random() + a.magnitude)
    }
    let bitCount = T.Magnitude.bitWidth - difference.leadingZeroBitCount
    var temporary: T.Magnitude
    repeat {
      temporary = _random(bitCount: bitCount)
    } while temporary > difference
    return test ? T(temporary - a.magnitude) : T(temporary + a.magnitude)
  }

  @_transparent // @_inlineable
  public func uniform<T : FixedWidthInteger & SignedInteger>(
    _: T.Type = T.self
  ) -> T where T.Magnitude : FixedWidthInteger & UnsignedInteger {
    return uniform(a: T.min, b: T.max)
  }

  @_transparent // @_inlineable
  public func uniform<T : FixedWidthInteger & SignedInteger>(
    _: T.Type = T.self, a: T, b: T, count: Int
  ) -> UnfoldSequence<T, Int>
  where T.Magnitude : FixedWidthInteger & UnsignedInteger {
    precondition(count >= 0, "Element count should be non-negative")
    return sequence(state: 0) { (state: inout Int) -> T? in
      defer { state += 1 }
      return state == count ? nil : self.uniform(a: a, b: b)
    }
  }

  @_transparent // @_inlineable
  public func uniform<T : FixedWidthInteger & SignedInteger>(
    _: T.Type = T.self, count: Int
  ) -> UnfoldSequence<T, Int>
  where T.Magnitude : FixedWidthInteger & UnsignedInteger {
    return uniform(a: T.min, b: T.max, count: count)
  }
}

// TODO: Document methods in this extension.

// FIXME: If `FloatingPoint.init(_: FixedWidthInteger)` is added
// then it becomes possible to remove the constraint `Element == UInt64`.
extension PRNG where Element == UInt64 {
  // @_versioned
  internal func _random<T : BinaryFloatingPoint>(
    _: T.Type = T.self, bitCount: Int = T.significandBitCount
  ) -> T {
    let bitCount = Swift.min(bitCount, T.significandBitCount)
    let (quotient, remainder) =
      bitCount.quotientAndRemainder(dividingBy: Self._maxRandomBitCount)
    let k = Swift.max(1, remainder == 0 ? quotient : quotient + 1)
    let step = T(Self.max - Self.min)
    let initial = (0 as T, 1 as T)
    // Call `next()` exactly `k` times.
    let (dividend, divisor) = prefix(k).reduce(initial) { partial, next in
      let x = partial.0 + T(next - Self.min) * partial.1
      let y = partial.1 + step * partial.1
      return (x, y)
    }
    return dividend / divisor
  }

  /* public */ func uniform<T : BinaryFloatingPoint>(
    _: T.Type = T.self, a: T, b: T
  ) -> T {
    precondition(
      b > a,
      "Uniform distribution parameter b should be greater than a"
    )
    return (b - a) * _random() + a
  }

  @_transparent // @_inlineable
  /* public */ func uniform<T : BinaryFloatingPoint>(_: T.Type = T.self) -> T {
    return uniform(a: 0, b: 1)
  }

  @_transparent // @_inlineable
  /* public */ func uniform<T : BinaryFloatingPoint>(
    _: T.Type = T.self, a: T, b: T, count: Int
  ) -> UnfoldSequence<T, Int> {
    precondition(count >= 0, "Element count should be non-negative")
    return sequence(state: 0) { (state: inout Int) -> T? in
      defer { state += 1 }
      return state == count ? nil : self.uniform(a: a, b: b)
    }
  }

  @_transparent // @_inlineable
  /* public */ func uniform<T : BinaryFloatingPoint>(
    _: T.Type = T.self, count: Int
  ) -> UnfoldSequence<T, Int> {
    return uniform(a: 0, b: 1, count: count)
  }
}
