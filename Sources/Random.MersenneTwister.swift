//
//  Random.MersenneTwister.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/16/17.
//

extension Random {
  /// A pseudo-random number generator that implements [`MT19937`][ref], a
  /// Mersenne Twister.
  ///
  /// [ref]: https://doi.org/10.1145%2F272991.272995
  /* public */ final class MersenneTwister : PRNG {
    // TODO: Document these public static properties.
    public static let (w, n, m) = (32, 624, 397)
    public static let (r, a) = (31, 0x9908b0df as UInt32)
    public static let (u, d) = (11, 0xffffffff as UInt32)
    public static let (s, b) = ( 7, 0x9d2c5680 as UInt32)
    public static let (t, c) = (15, 0xefc60000 as UInt32)
    public static let l = 18
    public static let f = 1812433253 as UInt32

    internal static let _lower = (1 as UInt32 &<< r) - 1
    internal static let _upper = ~_lower

    internal var _state: [UInt32]
    internal var _index = MersenneTwister.n

    public var state: [UInt32] {
      get {
        return _state
      }
      set {
        precondition(newValue.count == MersenneTwister.n)
        _state = newValue
      }
    }

    // TODO: Document this property.
    public var index: Int {
      get {
        return _index
      }
      set {
        precondition(newValue >= 0 && newValue <= MersenneTwister.n)
        _index = newValue
      }
    }

    // TODO: Document this function.
    internal func _twist() {
      for i in 0..<MersenneTwister.n {
        let x = (_state[i] & MersenneTwister._upper) &+
          (_state[(i + 1) % MersenneTwister.n] & MersenneTwister._lower)
        let xA = x % 2 == 0 ? x &>> 1 : (x &>> 1) ^ MersenneTwister.a
        _state[i] = _state[(i + MersenneTwister.m) % MersenneTwister.n] ^ xA
      }
      _index = 0
    }

    public func next() -> UInt32? {
      if _index == MersenneTwister.n { _twist() }
      var y = _state[_index]
      y ^= (y &>> MersenneTwister.u) & MersenneTwister.d
      y ^= (y &<< MersenneTwister.s) & MersenneTwister.b
      y ^= (y &<< MersenneTwister.t) & MersenneTwister.c
      y ^= (y &>> MersenneTwister.l)
      _index += 1
      return y
    }

    /// Creates a pseudo-random number generator with an internal state seeded
    /// using the given value.
    ///
    /// - Parameters:
    ///   - seed: The value to be used as the seed.
    public init(seed: UInt32) {
      self._state = [UInt32](repeating: 0, count: MersenneTwister.n)
      var next = seed
      self._state[0] = next
      for i in 1..<MersenneTwister.n {
        next = MersenneTwister.f &* (next ^ (next &>> (MersenneTwister.w - 2)))
          &+ UInt32(i)
        self._state[i] = next
      }
    }

    public init(state: [UInt32]) {
      precondition(state.count == MersenneTwister.n)
      self._state = state
    }

    public convenience init?() {
      guard let entropy = MersenneTwister._entropy(UInt32.self) else {
        return nil
      }
      self.init(seed: entropy)
    }
  }
}
