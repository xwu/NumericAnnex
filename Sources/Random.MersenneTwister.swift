//
//  Random.MersenneTwister.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/16/17.
//

extension Random {
  /// A pseudo-random number generator that implements [`MT19937`][ref], a
  /// twisted generalized feedback shift register.
  ///
  /// [ref]: https://doi.org/10.1145%2F272991.272995
  /* public */ final class MersenneTwister : PRNG {
    internal static let (_w, _n, _m) = (32, 624, 397)
    internal static let (_r, _a) = (31, 0x9908b0df as UInt32)
    // -------------------------------------------------------------------------
    // Masks.
    internal static let _lower = (1 as UInt32 &<< _r) &- 1
    internal static let _upper = ~_lower
    // -------------------------------------------------------------------------
    internal static let (_u, _d) = (11, 0xffffffff as UInt32)
    internal static let (_s, _b) = ( 7, 0x9d2c5680 as UInt32)
    internal static let (_t, _c) = (15, 0xefc60000 as UInt32)
    internal static let _l = 18
    // -------------------------------------------------------------------------
    // Initialization multiplier.
    internal static let _f = 1812433253 as UInt32
    // -------------------------------------------------------------------------

    internal var _state: (array: [UInt32], index: Int)

    public var state: (array: [UInt32], index: Int) {
      get {
        return _state
      }
      set {
        precondition(
          newValue.array.count == MersenneTwister._n &&
            (0...MersenneTwister._n).contains(newValue.index)
        )
        _state = newValue
      }
    }

    internal func _twist() {
      for i in 0..<MersenneTwister._n {
        let x = (_state.array[i] & MersenneTwister._upper) &+
          (_state.array[(i &+ 1) % MersenneTwister._n] & MersenneTwister._lower)
        let xA = x % 2 == 0 ? x &>> 1 : (x &>> 1) ^ MersenneTwister._a
        _state.array[i] =
          _state.array[(i &+ MersenneTwister._m) % MersenneTwister._n] ^ xA
      }
      _state.index = 0
    }

    public func next() -> UInt32? {
      if _state.index == MersenneTwister._n { _twist() }
      var y = _state.array[_state.index]
      y ^= (y &>> MersenneTwister._u) & MersenneTwister._d
      y ^= (y &<< MersenneTwister._s) & MersenneTwister._b
      y ^= (y &<< MersenneTwister._t) & MersenneTwister._c
      y ^= (y &>> MersenneTwister._l)
      _state.index += 1
      return y
    }

    /// Creates a pseudo-random number generator with an internal state seeded
    /// using the given value.
    ///
    /// - Parameters:
    ///   - seed: The value to be used as the seed.
    public init(seed: UInt32) {
      var array = [UInt32](repeating: 0, count: MersenneTwister._n)
      array[0] = seed
      for i in 1..<MersenneTwister._n {
        let previous = array[i &- 1]
        array[i] = UInt32(i) &+
          MersenneTwister._f &*
            (previous ^ (previous &>> (MersenneTwister._w &- 2)))
      }
      self._state = (array: array, index: MersenneTwister._n)
    }

    public init(state: (array: [UInt32], index: Int)) {
      precondition(
        state.array.count == MersenneTwister._n &&
          (0...MersenneTwister._n).contains(state.index)
      )
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
