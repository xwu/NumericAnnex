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
    // TODO: Document these static properties.
    public static let (w, n, m) = (32, 624, 397)
    public static let (r, a) = (31, 0x9908b0df as UInt32)
    public static let (u, d) = (11, 0xffffffff as UInt32)
    public static let (s, b) = ( 7, 0x9d2c5680 as UInt32)
    public static let (t, c) = (15, 0xefc60000 as UInt32)
    public static let l = 18
    public static let f = 1812433253 as UInt32
    internal static let _lower = (1 as UInt32 &<< r) &- 1
    internal static let _upper = ~_lower

    // TODO: Document this property.
    internal var _state: (array: [UInt32], index: Int)

    public var state: (array: [UInt32], index: Int) {
      get {
        return _state
      }
      set {
        precondition(
          newValue.array.count == MersenneTwister.n &&
            (0...MersenneTwister.n).contains(newValue.index)
        )
        _state = newValue
      }
    }

    // TODO: Document this function.
    internal func _twist() {
      for i in 0..<MersenneTwister.n {
        let x = (_state.array[i] & MersenneTwister._upper) &+
          (_state.array[(i &+ 1) % MersenneTwister.n] & MersenneTwister._lower)
        let xA = x % 2 == 0 ? x &>> 1 : (x &>> 1) ^ MersenneTwister.a
        _state.array[i] =
          _state.array[(i &+ MersenneTwister.m) % MersenneTwister.n] ^ xA
      }
      _state.index = 0
    }

    public func next() -> UInt32? {
      if _state.index == MersenneTwister.n { _twist() }
      var y = _state.array[_state.index]
      y ^= (y &>> MersenneTwister.u) & MersenneTwister.d
      y ^= (y &<< MersenneTwister.s) & MersenneTwister.b
      y ^= (y &<< MersenneTwister.t) & MersenneTwister.c
      y ^= (y &>> MersenneTwister.l)
      _state.index += 1
      return y
    }

    /// Creates a pseudo-random number generator with an internal state seeded
    /// using the given value.
    ///
    /// - Parameters:
    ///   - seed: The value to be used as the seed.
    public init(seed: UInt32) {
      var array = [UInt32](repeating: 0, count: MersenneTwister.n)
      array[0] = seed
      for i in 1..<MersenneTwister.n {
        let previous = array[i &- 1]
        array[i] = UInt32(i) &+
          MersenneTwister.f &*
            (previous ^ (previous &>> (MersenneTwister.w &- 2)))
      }
      self._state = (array: array, index: MersenneTwister.n)
    }

    public init(state: (array: [UInt32], index: Int)) {
      precondition(
        state.array.count == MersenneTwister.n &&
          (0...MersenneTwister.n).contains(state.index)
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
