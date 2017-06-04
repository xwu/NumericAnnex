//
//  Random.Xoroshiro.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/16/17.
//

extension Random {
  /// A pseudo-random number generator (PRNG) that implements `xoroshiro128+`, a
  /// successor to `xorshift128+` devised by S. Vigna and D. Blackman.
  ///
  /// To generate random numbers, create your own instance of `Random.Xoroshiro`
  /// with an internal state seeded from cryptographically secure random bytes:
  ///
  /// ```swift
  /// let random = Random.Xoroshiro()!
  /// let x = random.uniform() as Int
  ///
  /// // You can also pass the desired result type as an argument.
  /// let y = random.uniform(Int.self)
  ///
  /// if x > y {
  ///   print("Here's a random value between 0 and 42 (inclusive):")
  ///   print(random.uniform(0, 42))
  /// } else {
  ///   print("Here's a random value between -42 and 0 (inclusive):")
  ///   print(random.uniform(-42, 0))
  /// }
  /// ```
  ///
  /// - Warning: Once seeded from cryptographically secure random bytes,
  ///   `Random.Xoroshiro` generates high-quality random numbers but is _not_ a
  ///   cryptographically secure PRNG.
  ///
  /// - SeeAlso: `Random`, `PRNG`
  public final class Xoroshiro : PRNG {
    /// The internal state of the pseudo-random number generator.
    public var state: (UInt64, UInt64)

    /// Creates a pseudo-random number generator with the given internal state.
    ///
    /// - Parameters:
    ///   - state: The value to be used as the generator's internal state.
    public init(state: (UInt64, UInt64)) {
      self.state = state
    }

    /// Creates a pseudo-random number generator with an internal state seeded
    /// using cryptographically secure random bytes.
    ///
    /// If cryptographically secure random bytes are unavailable, the result is
    /// `nil`.
    public init?() {
      repeat {
        guard let entropy = Xoroshiro._entropy(UInt64.self, count: 2) else {
          return nil
        }
        self.state = (entropy[0], entropy[1])
      } while self.state == (0, 0)
    }

    // @_versioned
    internal static func _rotl(_ value: UInt64, _ count: Int) -> UInt64 {
      // TODO: Document this function.
      return (value &<< count) | (value &>> (64 &- count))
    }

    public func next() -> UInt64? {
      let x = state.0
      var y = state.1
      let result = x &+ y
      y ^= x
      state.0 = Xoroshiro._rotl(x, 55) ^ y ^ (y &<< 14)
      state.1 = Xoroshiro._rotl(y, 36)
      return result
    }
  }
}
